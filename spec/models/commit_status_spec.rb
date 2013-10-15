require 'spec_helper'

describe CommitStatus do
  let(:resource) { double("resource") }
  let(:user) { "fakey" }
  let(:token) { "ABCDEF123" }

  context "with a username and token" do

    before do
      ENV["GITHUB_API_USER"], ENV["GITHUB_API_TOKEN"] = user, token
    end

    it 'sets a pending status' do
      build = builds(:one)
      repo_name = build.project.repo
      sha       = build.sha
      endpoint = "https://api.github.com/repos/#{repo_name}/statuses/#{sha}"

      # Here's where we get RestClient::Resource to return the fake "resource" we're injecting...
      expect(RestClient::Resource).to receive(:new).with(endpoint, user, token).and_return(resource)

      commit_json = '{"state":"pending","description":"Build pending.","target_url":"http://localhost:6161/builds/1"}'
      dict = { content_type: :json, accept: :json }

      # ... and here's where we tell it how it should be called:
      expect(resource).to receive(:post).with(commit_json, dict).and_return(nil)

      CommitStatus.mark build.id, :pending
      # If +resource+ doesn't get sent :post, or gets the wrong arguments, boom! spec failure.
    end
  end
end
