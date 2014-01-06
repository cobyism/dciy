require 'spec_helper'

describe ProjectsController do
  let(:project) { projects(:one) }

  it "should get index" do
    get :index
    expect(response).to be_success
    expect(assigns :projects).not_to be_nil
  end

  it "should get new" do
    get :new
    expect(response).to be_success
    expect(assigns :project).not_to be_nil
  end

  it "should create project" do
    expect do
      post :create, project: { repo: 'foo/bar.git', github_host: 'github.internal.com' }
    end.to change { Project.count }.by(1)

    p = assigns :project
    expect(p.repo).to eq('foo/bar.git')
    expect(p.github_host).to eq('github.internal.com')

    expect(response).to redirect_to(project_path(p))
  end

  it "should show project" do
    get :show, id: project
    expect(assigns :project).to eq(project)
    expect(response).to be_success
  end

  it "should get edit" do
    get :edit, id: project
    expect(assigns :project).to eq(project)
    expect(response).to be_success
  end

  it "should update project" do
    patch :update, id: project, project: {
      repo: 'something/different.git',
      github_host: 'github.something.com'
    }

    p = assigns :project
    expect(p.repo).to eq('something/different.git')
    expect(p.github_host).to eq('github.something.com')

    assert_redirected_to project_path(assigns(:project))
  end

  it "should destroy project" do
    expect { delete :destroy, id: project }.to change { Project.count }.by(-1)

    expect(response).to redirect_to(projects_path)
  end
end
