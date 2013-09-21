class RemoveRunSpecificFields < ActiveRecord::Migration
  def change
    change_table :post_build_actions do |t|
      t.remove :started_at, :completed_at, :successful
    end
  end
end
