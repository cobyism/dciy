class AddGithubHostToProject < ActiveRecord::Migration
  def change
    add_column :projects, :github_host, :text, default: 'github.com'
  end
end
