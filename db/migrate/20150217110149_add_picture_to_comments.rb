class AddPictureToComments < ActiveRecord::Migration
  def change
    add_column :comments, :picture, :string
    add_column :comments, :caption, :text
    add_column :comments, :caption_markdown, :text
  end
end
