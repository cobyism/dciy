require 'spec_helper'

describe Project do
  let(:project) { Project.create! repo: 'cobyism/dciy.git' }

  it 'generates a git URI' do
    expect(project.repo_uri).to eq('https://github.com/cobyism/dciy.git')
  end

  it 'derives a workspace path' do
    expect(project.workspace_path.to_s).to match(%r{workspace/project-#{project.id}-cobyism-dciy.git$})
  end
end
