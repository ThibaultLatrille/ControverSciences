class AddBinaryToTimelines < ActiveRecord::Migration
  def change
    add_column :timelines, :binary, :string, default: ''
  end
end
