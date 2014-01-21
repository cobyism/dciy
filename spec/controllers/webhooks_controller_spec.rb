require 'spec_helper'

describe WebhooksController do

  describe "POST 'receive'" do
    let!(:project) { Project.create! repo: 'cobyism/dciy' }

    it "creates a new build for that ref, on that project" do
      expect(BuildWorker).to receive(:perform_async)

      # Reference:
      # https://help.github.com/articles/post-receive-hooks#the-payload
      expect do
        post :receive, project_id: project.id, payload: { ref: 'refs/heads/master' }.to_json
      end.to change { project.builds.count }.by(1)

      expect(response).to be_success
      expect(project.builds).to have(1).item
      b = project.builds[0]
      expect(b.branch).to eq("master")
    end

    it "returns a 404 on unknown projects" do
      post :receive, project_id: 9999999, payload: { ref: 'refs/heads/master' }.to_json

      expect(response).to be_not_found
    end
  end

end
