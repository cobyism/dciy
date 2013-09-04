class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :project_id
      t.datetime :started_at
      t.datetime :completed_at
      t.boolean :successful
      t.text :output

      t.timestamps
    end
  end
end
