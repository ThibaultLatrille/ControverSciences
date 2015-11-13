class AddPatchesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :target_patches, :integer, :default => 0
  end
end
