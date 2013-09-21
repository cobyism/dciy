require 'spec_helper'

describe PostBuildAction do
  let(:project) { Project.create! }
  let(:action) { PostBuildAction.create! project: project }

  let(:successful_build) { Build.create! project: project, sha: 'master', successful: true }
  let(:failed_build) { Build.create! project: project, sha: 'master', successful: false }

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

  context 'for successful builds' do
    let(:action) { project_action trigger_on_status: PostBuildAction::SUCCESS }

    it 'cares about succeeded builds' do
      expect(PostBuildAction.that_care_about successful_build).to eq([action])
    end

    it "doesn't care about failed builds" do
      expect(PostBuildAction.that_care_about failed_build).to be_empty
    end
  end

  context 'for failed builds' do
    it "doesn't trigger on succeeded builds"
    it 'triggers on failed builds'
  end

  context 'for every build' do
    it 'triggers on succeeded builds'
    it 'triggers on failed builds'
  end
end
