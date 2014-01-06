require 'spec_helper'

describe CommitStatus do
  let(:resource) { double("resource") }
  let(:user) { "fakey" }
  let(:token) { "ABCDEF123" }

  def expect_post build, endpoint, payload
    repo_name = build.project.repo
    sha = build.sha
    expect(RestClient::Resource).to receive(:new).with(endpoint, user, token).and_return(resource)

    dict = { content_type: :json, accept: :json }
    expect(resource).to receive(:post).with(payload.to_json, dict).and_return(nil)
  end

  context "with a username and token" do
    before do
      ENV["GITHUB_API_USER"], ENV["GITHUB_API_TOKEN"] = user, token
    end

    it 'sets a pending status' do
      build = builds(:one)
      endpoint = "https://api.github.com/repos/#{build.project.repo}/statuses/#{build.sha}"
      expect_post build, endpoint, {
        state: "pending",
        description: "Build pending.",
        target_url: "http://localhost:6161/builds/#{build.id}"
      }

      CommitStatus.mark build.id, :pending
      # If +resource+ doesn't get sent :post, or gets the wrong arguments, boom! spec failure.
    end

    it "uses the project's GitHub API endpoint" do
      build = builds(:two)
      endpoint = "https://github.internal.com/api/v3/repos/#{build.project.repo}/statuses/#{build.sha}"
      expect_post build, endpoint, {
        state: "pending",
        description: "Build pending.",
        target_url: "http://localhost:6161/builds/#{build.id}"
      }

      CommitStatus.mark build.id, :pending
    end
  end
end
