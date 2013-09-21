require 'spec_helper'

describe PostBuildAction do
  let(:project) { Project.create! }

  let(:successful_build) { Build.create! project: project, sha: 'master', successful: true }
  let(:failed_build) { Build.create! project: project, sha: 'master', successful: false }
  let(:deploy_build) { Build.create! project: project, sha: 'deploy', successful: true }

  def project_action hash
    attrs = { project: project }.merge hash
    PostBuildAction.create! attrs
  end

  it 'must have a project id' do
    expect(PostBuildAction.create trigger_on_status: PostBuildAction::ALL).not_to be_valid
  end

  it 'must specify what builds it cares about' do
    expect(PostBuildAction.create project: project).not_to be_valid
  end

  it 'enforces a valid trigger_on_status' do
    expect(PostBuildAction.create project: project, trigger_on_status: 42).not_to be_valid
  end

  # Save some redundancy in the specs below that determine which actions are triggered by
  # which builds.

  def self.it_cares_about build_desc
    it "cares about #{build_desc.to_s.humanize.downcase.pluralize}" do
      build = send build_desc
      expect(PostBuildAction.that_care_about build).to eq([action])
    end
  end

  def self.it_doesnt_care_about build_desc
    it "doesn't care about #{build_desc.to_s.humanize.downcase.pluralize}" do
      build = send build_desc
      expect(PostBuildAction.that_care_about build).to be_empty
    end
  end

  context 'for successful builds' do
    let!(:action) { project_action trigger_on_status: PostBuildAction::SUCCESS }

    it_cares_about :successful_build
    it_doesnt_care_about :failed_build
    it_cares_about :deploy_build
  end

  context 'for failed builds' do
    let!(:action) { project_action trigger_on_status: PostBuildAction::FAILURE }

    it_doesnt_care_about :successful_build
    it_cares_about :failed_build
    it_doesnt_care_about :deploy_build
  end

  context 'for every build' do
    let!(:action) { project_action trigger_on_status: PostBuildAction::ALL }

    it_cares_about :successful_build
    it_cares_about :failed_build
    it_cares_about :deploy_build
  end

  context 'for certain branches' do
    let!(:action) { project_action trigger_on_status: PostBuildAction::ALL, trigger_on_branch: 'deploy' }

    it_doesnt_care_about :successful_build
    it_doesnt_care_about :failed_build
    it_cares_about :deploy_build
  end
end
