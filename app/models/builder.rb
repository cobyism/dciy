# Shamelessly stolen from
# https://github.com/integrity/integrity

class Builder
  def self.build(_build, directory)
    new(_build, directory).build
  end

  def initialize(build, directory)
    @build     = build
    @directory = directory
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
    # @logger.info "Started building #{project.repo} at #{commit}"
    # @build.raise_on_save_failure = true
    @build.update(:started_at => Time.now)
    # @build.project.enabled_notifiers.each { |n| n.notify_of_build_start(@build) }
    checkout.run
    # checkout.metadata invokes git and may fail
    # @build.commit.raise_on_save_failure = true
    # @build.commit.update(checkout.metadata)
  end

  def run
    @result = checkout.run_in_dir(command) do |chunk|
      yield chunk
    end
  end

  def add_output(chunk)
    output = @build.output
    output << chunk
    @build.output = output
    @build.save
    # @build.update(:output => @build.output + chunk)
  end

  def complete
    @logger.info "Build #{commit} exited with #{@result.success} got:\n #{@result.output}"

    # @build.raise_on_save_failure = true
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

  # def notify
  #   @build.notify
  # end

  def checkout
    @checkout ||= Checkout.new(project, commit, directory)
  end

  def directory
    @_directory ||= @directory #.join(@build.id.to_s)
  end

  def project
    @build.project
  end

  def command
    @build.command
  end

  def commit
    @build.sha
  end
end
