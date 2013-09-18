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
    @results   = []
  end

  def run_run_run
    do_ascii_header
    begin
      do_checkout
      run_prepare && run_ci
    rescue CantFindBuildFile
      no_build_file
    rescue Interrupt, SystemExit
      raise
    rescue Exception => e
      fail(e)
    else
      complete
    end
  end

  def do_ascii_header
    ascii = <<-EOF
    _/_/_/      _/_/_/  _/_/_/  _/      _/
   _/    _/  _/          _/      _/  _/
  _/    _/  _/          _/        _/
 _/    _/  _/          _/        _/
_/_/_/      _/_/_/  _/_/_/      _/

Built with <3 by DCIY
https://github.com/cobyism/dciy

EOF
    add_output(ascii)
  end

  def do_checkout
    add_dciy_build_output "Aight, let's do this!"

    @logger.info "Started building #{@project.repo} at #{@build.sha}"
    @build.update(:started_at => Time.now)

    unless File.exists?(@directory)
      add_dciy_build_output "Cloning repository..."
      in_terminal.run "git clone #{@project.repo_uri} #{@directory}"
    end

    add_dciy_build_output "Checking out project at #{sha_for_branch}..."
    in_terminal.run "git fetch origin", @directory

    add_dciy_build_output in_terminal.run("git reset --hard #{sha_for_branch}", @directory).output
    # run init separately for compatibility with old versions of git
    add_dciy_build_output "Setting up submodules, if you're into that kind of thing..."
    in_terminal.run "git submodule init", @directory
    in_terminal.run "git submodule update", @directory
  end

  def run_prepare
    run_commands 'preparation', @project.prepare_commands
  end

  def run_ci
    run_commands 'CI', @project.ci_commands
  end

  def run_commands category, cmd_list
    cmd_list.each do |cmd|
      add_dciy_build_output "Running #{category} command <#{cmd}>...\n"
      r = in_terminal.run(cmd, @project.workspace_path) do |chunk|
        add_output(chunk)
      end
      @results << r
      return false unless r.success
    end
  end

  def add_output(chunk)
    @build.update(:output => @build.output + chunk)
  end

  def add_dciy_build_output(message)
    add_output "[DCIY] #{message}\n"
  end

  def complete
    overall_success = @results.all?(&:success)
    combined_output = @results.map(&:output).join("\n")

    @logger.info "Build #{@project.repo} @ #{@build.sha} exited with #{overall_success} got:\n #{combined_output}"
    @build.update(
      :completed_at => Time.now,
      :successful   => overall_success,
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
      :successful   => false,
      :output       => @build.output + failure_message
    )
  end

  def no_build_file
    @logger.info "Build #{@build.sha} could not run because no build information was found."

    failure_message = <<-EOF
I don't know how to build this project!

Please create a "dciy.toml" file in the root directory of your project with contents
like the following, and try again.

[dciy.commands]
prepare = ["script/bootstrap"]
cibuild = ["script/cibuild"]
EOF

    @build.update(
      :completed_at => Time.now,
      :successful   => false,
      :output       => @build.output + failure_message
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
