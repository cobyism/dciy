class CreatePostBuildActions < ActiveRecord::Migration
  def change
    create_table :post_build_actions do |t|
      # PostBuildAction
      t.string :type
      t.integer :project_id
      t.integer :trigger_on_status
      t.boolean :successful
      t.datetime :started_at
      t.datetime :completed_at
      t.timestamps

      # BranchPushAction
      t.string :source_branch
      t.string :target_repo_uri
      t.string :target_branch
    end
  end
end
