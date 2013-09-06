class BuildWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(build_id)
    build = Build.find_by_id(build_id)
    project = build.project

    # This needs to not be nil otherwise apparently shit can get weird.
    build.output = ""
    build.save

    Runner.go_nuts_on(build)
  end
end
