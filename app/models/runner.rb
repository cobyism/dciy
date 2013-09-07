# Shamelessly stolen from
# https://github.com/integrity/integrity

class Runner

  def self.go_nuts_on(build)
    new(build).run_run_run
  end

  def initialize(build)
    @build     = build
    @project   = build.project
    @directory = @project.workspace_path
    @logger    = Logger.new(STDOUT)
  end

  def run_run_run
    begin
      do_checkout
      run_ci
    rescue Interrupt, SystemExit
      raise
    rescue Exception => e
      fail(e)
    else
      complete
    end
  end

  def do_checkout
    @logger.info "Started building #{@project.repo} at #{@build.sha}"
    @build.update(:started_at => Time.now)

    unless File.exists?(@directory)
      in_terminal.run "git clone #{@project.repo_uri} #{@directory}"
    end

    in_terminal.run "git fetch origin", @directory
    in_terminal.run "git reset --hard #{sha_for_branch}", @directory
    # run init separately for compatibility with old versions of git
    in_terminal.run "git submodule init", @directory
    in_terminal.run "git submodule update", @directory
    r = in_terminal.run "git show HEAD --pretty=oneline --summary", @directory
    @logger.info "Checked out #{@project.repo} at #{@build.sha}"
    @logger.info "Current head: #{r.output}"
  end

  def run_ci
    @result = in_terminal.run(@build.ci_command, @build.project.workspace_path) do |chunk|
      add_output(chunk)
    end
  end

  def add_output(chunk)
    output = @build.output
    output << chunk
    @build.output = output
    @build.save
  end

  def complete
    @logger.info "Build #{@build.sha} exited with #{@result.success} got:\n #{@result.output}"
    @build.update(
      :completed_at => Time.now,
      :successful   => @result.success,
      :output       => @result.output
    )
  end

  def fail(exception)
    failure_message = "#{exception.class}: #{exception.message}"

    @logger.info "Build #{@build.sha} failed with an exception: #{failure_message}"

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

  def in_terminal
    @commander ||= Command.new
  end

  def sha_for_branch
    @build.sha.match(/\b[0-9a-f]{5,40}\b/) ? @build.sha : find_head(@build.sha)
  end

  def find_head(ref)
    result = in_terminal.run("git ls-remote --heads #{@project.repo_uri} #{ref}")
    unless result.output.nil?
      result.output.split.first
    else
      "master"
    end
  end
end
