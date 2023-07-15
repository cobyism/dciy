class CreateBuilds < ActiveRecord::Migration[7.0]
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
