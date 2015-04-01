class AddBinaryToTimelines < ActiveRecord::Migration
  def change
    add_column :timelines, :binary, :string, default: ''
    add_column :timelines, :binary_0, :integer, default: 0
    add_column :timelines, :binary_1, :integer, default: 0
    add_column :timelines, :binary_2, :integer, default: 0
    add_column :timelines, :binary_3, :integer, default: 0
    add_column :timelines, :binary_4, :integer, default: 0
    add_column :timelines, :binary_5, :integer, default: 0
  end
end
