class AddBranchToBuild < ActiveRecord::Migration[7.0]
  def change
    add_column :builds, :branch, :string
  end
end
