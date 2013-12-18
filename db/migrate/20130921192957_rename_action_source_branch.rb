class RenameActionSourceBranch < ActiveRecord::Migration
  def change
    change_table :post_build_actions do |t|
      t.rename :source_branch, :trigger_on_branch
    end
  end
end
