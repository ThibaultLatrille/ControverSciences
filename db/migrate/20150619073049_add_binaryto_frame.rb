class AddBinarytoFrame < ActiveRecord::Migration
  def change
    add_column :frames, :binary, :text, :default => ""
  end
end
