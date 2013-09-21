class BranchPushAction < PostBuildAction
  validates :target_repo_uri, presence: true
  validates :target_branch, presence: true

  def execute_within runner
    runner.in_terminal.run "git push #{target_repo_uri} #{runner.build.sha}:#{target_branch}"
  end
end
