class AddTitleToComments < ActiveRecord::Migration
  def change
    add_column :comments, :title, :text, default: ''
    add_column :comments, :title_markdown, :text, default: ''
  end
end
