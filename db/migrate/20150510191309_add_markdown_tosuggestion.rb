class AddMarkdownTosuggestion < ActiveRecord::Migration
  def change
    add_column :suggestions, :content_markdown, :text, default: ""
    add_column :suggestion_children, :content_markdown, :text, default: ""
  end
end
