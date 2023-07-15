class AddShaToBuild < ActiveRecord::Migration[7.0]
  def change
    add_column :builds, :sha, :string
  end
end
