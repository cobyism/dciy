require 'rest_client'

class CommitStatus

  class << self

    def enabled?
      ENV["GITHUB_API_USER"].present? && ENV["GITHUB_API_TOKEN"].present?
    end

    def mark(build_id, state)

      build = Build.find(build_id)

      case state
      when :pending
        message = "Build pending."
      when :success
        message = build.status_phrase
      when :error
        message = build.status_phrase
      when :failure
        message = build.status_phrase
      end

      commit_status = {
        "state" => state.to_s,
        "description" => message,
        "target_url" => "http://localhost:6161/builds/#{build.id}"
      }

      endpoint = "https://api.github.com/repos/#{build.project.repo}/statuses/#{build.sha}"
      repo = RestClient::Resource.new endpoint, ENV["GITHUB_API_USER"], ENV["GITHUB_API_TOKEN"]

      response = repo.post commit_status.to_json, :content_type => :json, :accept => :json
    end

  end

end
