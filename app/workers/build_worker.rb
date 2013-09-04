class BuildWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(build_id)
    build = Build.find_by_id(build_id)
    count_to = 20000

    build.started_at = Time.now
    build.save

    build.output = "Counting to #{count_to}\n"
    build.save

    (0..count_to).each do |i|
      build.output << "=> #{i}\n"
      build.save
    end

    build.output << "\nFinished!"
    build.save

    build.successful = true
    build.save

    build.completed_at = Time.now
    build.save

  end
end
