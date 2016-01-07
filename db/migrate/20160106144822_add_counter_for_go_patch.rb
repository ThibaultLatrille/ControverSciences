class AddCounterForGoPatch < ActiveRecord::Migration
  def change
    add_column :go_patches, :counter, :integer, default: 0
  end
end
