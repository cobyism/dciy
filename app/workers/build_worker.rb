class BuildWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(build_id)
    build = Build.find_by_id(build_id)
    project = build.project
    build.output = ""
    build.save
    Builder.build(build, project.workspace_path, Logger.new(STDOUT))
  end

end
