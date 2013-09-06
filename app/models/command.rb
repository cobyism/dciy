# A ton of this is shamelessly stolen from:
# https://github.com/integrity/integrity

class Command

  Result = Struct.new(:success, :output)

  def initialize(build_output_interval = nil)
    @build_output_interval = build_output_interval || 5
  end

  def run(command, directory = nil)
    output = ""
    rd, wr = IO.pipe
    with_clean_env do
      if pid = fork
        # parent
        wr.close
        while true
          fds, = IO.select([rd], nil, nil, @build_output_interval)
          if fds
            # should have some data to read
            begin
              chunk = rd.read_nonblock(10240)
              if block_given?
                yield chunk
              end
              output += chunk
            rescue Errno::EAGAIN, Errno::EWOULDBLOCK
              # do select again
            rescue EOFError
              break
            end
          end
          # if fds are empty, timeout expired - run another iteration
        end
        rd.close
        Process.waitpid(pid)
      else
        # child
        rd.close
        STDOUT.reopen(wr)
        wr.close
        STDERR.reopen(STDOUT)
        if directory
          Dir.chdir(directory)
        end
        exec(command)
      end
    end

    Result.new($?.success?, output.chomp)
  end

  SIDE_EFFECT_VARS = %w(BUNDLE_GEMFILE RUBYOPT BUNDLE_BIN_PATH RBENV_DIR)
  def with_clean_env
    bundled_env = ENV.to_hash
    SIDE_EFFECT_VARS.each{ |var| ENV.delete(var) }
    yield
  ensure
    ENV.replace(bundled_env.to_hash)
  end

end
