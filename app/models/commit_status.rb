require 'rest_client'

class CommitStatus

  class << self

    def enabled?
      ENV["GITHUB_API_USER"].present? && ENV["GITHUB_API_TOKEN"].present?
    end

    def mark(build_id, state)

      build = Build.find(build_id)

      if state == :pending
        message = "Build pending."
      elsif [:success, :error, :failure].include? state
        message = build.status_phrase
      end

      commit_status = {
        "state" => state.to_s,
        "description" => message,
        "target_url" => "http://localhost:6161/builds/#{build.id}"
      }

      endpoint = "https://api.github.com/repos/#{build.project.repo}/statuses/#{build.sha}"
      repo_api = RestClient::Resource.new endpoint, ENV["GITHUB_API_USER"], ENV["GITHUB_API_TOKEN"]

      response = repo_api.post commit_status.to_json, :content_type => :json, :accept => :json
    end

  end

end
