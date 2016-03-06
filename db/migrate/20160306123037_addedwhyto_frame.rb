class AddedwhytoFrame < ActiveRecord::Migration
  def change
    add_column :frames, :why, :text, default: ''
    add_column :frames, :why_markdown, :text, default: ''
  end
end
