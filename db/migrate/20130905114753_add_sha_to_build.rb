class AddShaToBuild < ActiveRecord::Migration
  def change
    add_column :builds, :sha, :string
  end
end
