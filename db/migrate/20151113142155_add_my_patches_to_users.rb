class AddMyPatchesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :my_patches, :integer, :default => 0
  end
end
