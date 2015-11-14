class Rename < ActiveRecord::Migration
  def change
    rename_table :patches, :go_patches
  end
end
