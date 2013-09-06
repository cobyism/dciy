# Shamelessly stolen from
# https://github.com/integrity/integrity

class Builder
  def self.build(_build, directory, logger)
    new(_build, directory, logger).build
  end

  def initialize(build, directory, logger)
    @build     = build
    @directory = directory
    @logger    = logger
  end

  def build
    begin
      start
      run do |chunk|
        add_output(chunk)
      end
    rescue Interrupt, SystemExit
      raise
    rescue Exception => e
      fail(e)
    else
      complete
    end
    # notify
  end

  def start
    @logger.info "Started building #{project.repo} at #{commit}"
    @build.update(:started_at => Time.now)

    unless File.exists?(@directory)
      in_terminal.run "git clone #{project.repo_uri} #{@directory}"
    end

    in_terminal.run "git fetch origin", @directory
    in_terminal.run "git reset --hard #{sha}", @directory
    # run init separately for compatibility with old versions of git
    in_terminal.run "git submodule init", @directory
    in_terminal.run "git submodule update", @directory
  end

  def run
    @result = in_terminal.run(@build.ci_command, @build.project.workspace_path) do |chunk|
      yield chunk
    end
  end

  def add_output(chunk)
    output = @build.output
    output << chunk
    @build.output = output
    @build.save
  end

  def complete
    @logger.info "Build #{commit} exited with #{@result.success} got:\n #{@result.output}"
    @build.update(
      :completed_at => Time.now,
      :successful   => @result.success,
      :output       => @result.output
    )
  end

  def fail(exception)
    failure_message = "#{exception.class}: #{exception.message}"

    @logger.info "Build #{commit} failed with an exception: #{failure_message}"

    failure_message << "\n\n"
    exception.backtrace.each do |line|
      failure_message << line << "\n"
    end

    # @build.raise_on_save_failure = true
    @build.update(
      :completed_at => Time.now,
      :successful => false,
      :output => failure_message
    )
  end

  def directory
    @_directory ||= @directory
  end

  def project
    @build.project
  end

  def commit
    @commit ||= @build.sha
  end

  def in_terminal
    @commander ||= Command.new
  end

  def sha
    commit.match(/\b[0-9a-f]{5,40}\b/) ? find_head(commit) : commit
  end

  def find_head(ref)
    result = in_terminal.run("git ls-remote --heads #{project.repo_uri} #{ref}")
    unless result.output.nil?
      result.output.split.first
    else
      "master"
    end
  end
end
