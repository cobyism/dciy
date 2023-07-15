require 'spec_helper'

describe BuildsController do
  let(:project) { projects(:one) }
  let(:build) { builds(:one) }

  xit "should get index" do
    get :index

    expect(assigns :builds).not_to be_nil
    expect(response).to be_success
  end

  xit "should get new" do
    get :new

    b = assigns :build
    expect(b.branch).to eq('master')

    expect(response).to be_success
  end

  xit "should create build" do
    expect(BuildWorker).to receive(:perform_async)

    expect do
      post :create, build: { project_id: project, branch: 'some-branch' }
    end.to change { Build.count }.by(1)

    b = assigns :build

    expect(b).not_to be_nil
    expect(b.project).to eq(project)
    expect(b.branch).to eq('some-branch')

    expect(response).to redirect_to(build_path(b))
  end

  xit "should show build" do
    get :show, id: build

    expect(assigns :build).to eq(build)
    expect(response).to be_success
  end

  xit "should destroy build" do
    expect { delete :destroy, id: build.id }.to change { Build.count }.by(-1)

    expect(response).to redirect_to(builds_path)
  end
end
