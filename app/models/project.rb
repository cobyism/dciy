class Project < ActiveRecord::Base
  has_many :builds

  def workspace_path
    Rails.root.join("workspace", "project-#{self.id}-#{self.repo.gsub(/\//, '-')}")
  end

  def repo_uri
    "https://github.com/#{repo}"
  end
end
