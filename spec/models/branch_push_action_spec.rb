require 'spec_helper'

describe BranchPushAction do
  let(:project) { Project.create! }

  it 'needs a target repo uri' do
    expect(BranchPushAction.create(
      project: project,
      trigger_on_status: PostBuildAction::SUCCESS,
      target_branch: 'master'
    )).not_to be_valid
  end

  it 'needs a target branch' do
    expect(BranchPushAction.create(
      project: project,
      trigger_on_status: PostBuildAction::SUCCESS,
      target_repo_uri: 'git@some-heroku-app.com'
    )).not_to be_valid
  end

  it 'validates correctly' do
    expect(BranchPushAction.create(
      project: project,
      trigger_on_status: PostBuildAction::SUCCESS,
      target_repo_uri: 'git@some-heroku-app.com',
      target_branch: 'master'
    )).to be_valid
  end
end
