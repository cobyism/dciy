require 'rest_client'

class CommitStatus

  class << self

    def enabled?
      ENV["GITHUB_API_USER"].present? && ENV["GITHUB_API_TOKEN"].present?
    end

    def mark(repo_name, sha, state)

      case state
      when :pending
        message = "Build pending."
      when :success
        message = status_phrase
      when :error
        message = status_phrase
      when :failure
        message = status_phrase
      end

      commit_status = {
        "state" => state.to_s,
        "description" => message,
        "target_url" => "http://localhost:6161/builds/#{self.id}"
      }

      endpoint = "https://api.github.com/repos/#{repo_name}/statuses/#{sha}"
      repo = RestClient::Resource.new endpoint, ENV["GITHUB_API_USER"], ENV["GITHUB_API_TOKEN"]

      response = repo.post commit_status.to_json, :content_type => :json, :accept => :json
    end

  end

end
