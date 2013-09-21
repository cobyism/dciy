require 'spec_helper'
require 'time'

describe Build do
  let(:project) { Project.create! }
  let(:now) { Time.parse '1 Jan 2013 12:00am GMT' }

  before do
    allow(Time).to receive(:now).and_return(now)
  end

  # Quickly create a valid build.
  def valid_build hash
    attrs = { project_id: project.id, sha: 'master' }.merge(hash)
    Build.create! attrs
  end

  it 'needs a project id' do
    expect(Build.create(sha: 'master')).not_to be_valid
  end

  it 'needs a sha' do
    expect(Build.create(project_id: project.id)).not_to be_valid
  end

  context 'an unstarted build' do
    let(:build) { valid_build(created_at: 1.minute.ago) }

    it 'reports a :queued status' do
      expect(build.status).to eq(:queued)
    end

    it "shows a phrase indicating how long it's been waiting" do
      expect(build.status_phrase).to eq('Queued 1 minute ago')
    end
  end

  context 'a build in progress' do
    let(:build) { valid_build(started_at: 63.seconds.ago) }

    it 'reports a :pending status' do
      expect(build.status).to eq(:pending)
    end

    it 'shows a phrase indicating the time elapsed so far' do
      expect(build.status_phrase).to eq('Build started 1 minute ago')
    end
  end

  context 'a successful build' do
    let(:build) { valid_build successful: true, started_at: 123.seconds.ago, completed_at: now }

    it 'reports a :succeeded status' do
      expect(build.status).to eq(:succeeded)
    end

    it 'shows a phrase with the build duration' do
      expect(build.status_phrase).to eq('Succeeded in 2 minutes, 3 seconds')
    end

    it 'shows a phrase with the duration "instantly"' do
      instabuild = valid_build successful: true, started_at: 10.seconds.ago, completed_at: 10.seconds.ago
      expect(instabuild.status_phrase).to eq('Succeeded instantly')
    end
  end

  context 'a failed build' do
    let(:build) { valid_build successful: false, started_at: 123.seconds.ago, completed_at: now }

    it 'reports a failed status' do
      expect(build.status).to eq(:failed)
    end

    it 'shows a phrase with the build duration' do
      expect(build.status_phrase).to eq('Failed in 2 minutes, 3 seconds')
    end

    it 'shows a phrase with the duration "instantly"' do
      instabuild = valid_build successful: false, started_at: 10.seconds.ago, completed_at: 10.seconds.ago
      expect(instabuild.status_phrase).to eq('Failed instantly')
    end
  end

  # Common specs for the two MIA cases.
  def self.it_should_be_mia
    it 'reports an mia status' do
      expect(build.status).to eq(:mia)
    end

    it 'shows a missing status phrase' do
      expect(build.status_phrase).to eq('Missing, presumed dead')
    end
  end

  context 'a build that never started' do
    let(:build) { valid_build created_at: 2.hours.ago }
    it_should_be_mia
  end

  context 'a build that never finished' do
    let(:build) { valid_build started_at: 3.hours.ago }
    it_should_be_mia
  end
end
