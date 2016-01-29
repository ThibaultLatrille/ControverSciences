class AddFrameToBinary < ActiveRecord::Migration
  def change
    change_table :binaries do |t|
      t.integer :frame_id, index: true
    end
    remove_column :timelines, :binary_0
    remove_column :timelines, :binary_1
    remove_column :timelines, :binary_2
    remove_column :timelines, :binary_3
    remove_column :timelines, :binary_4
    remove_column :timelines, :binary_5
  end
end
