class BranchPushAction < PostBuildAction
  validates :target_repo_uri, presence: true
  validates :target_branch, presence: true

  def execute_for build
  end
end
