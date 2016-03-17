class AddCountdownToPatches < ActiveRecord::Migration
  def change
    add_column :go_patches, :countdown, :integer, :default => 0
  end
end
