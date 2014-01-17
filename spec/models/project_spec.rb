require 'spec_helper'

describe Project do
  let(:project) { Project.create! repo: 'cobyism/dciy.git' }

  it "requires a non-empty repo URI" do
    p = Project.create repo: ''
    expect(p).not_to be_valid
  end

  context 'with the default github uri' do
    it 'generates a git URI' do
      expect(project.repo_uri).to eq('https://github.com/cobyism/dciy.git')
    end

    it "locates the base URI for github's API" do
      expect(project.api_uri).to eq('https://api.github.com')
    end
  end

  context 'given a github:enterprise endpoint' do
    before do
      project.github_host = 'github.internal.com'
    end

    it 'generates git URIs within the instance' do
      expect(project.repo_uri).to eq('https://github.internal.com/cobyism/dciy.git')
    end

    it 'locates the API' do
      expect(project.api_uri).to eq('https://github.internal.com/api/v3')
    end
  end

  it 'derives a workspace path' do
    expect(project.workspace_path.to_s).to match(%r{workspace/project-#{project.id}-cobyism-dciy.git$})
  end
end
