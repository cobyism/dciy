class AddGithubHostToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :github_host, :text, default: 'github.com'
  end
end
