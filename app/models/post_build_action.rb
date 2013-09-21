class PostBuildAction < ActiveRecord::Base
  belongs_to :project

  # trigger_on_status constants. Determine which Builds will cause this
  # action to fire.
  SUCCESS = 1
  FAILURE = 2
  ALL = 3

  validates :project_id, presence: true
  validates :trigger_on_status, presence: true, inclusion: { in: [SUCCESS, FAILURE, ALL] }

  def self.that_care_about build
    triggers = [ALL, build.successful? ? SUCCESS : FAILURE]
    branches = [nil, build.sha]
    build.project.post_build_actions.where(trigger_on_status: triggers, trigger_on_branch: branches)
  end
end
