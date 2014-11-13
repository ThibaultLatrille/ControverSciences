class AddContentMarkdownToComments < ActiveRecord::Migration
  def change
    add_column :comments, :content_markdown, :text
  end
end
