class AddedwhytoFrame < ActiveRecord::Migration
  def change
    add_column :frames, :why, :text, default: ''
  end
end
