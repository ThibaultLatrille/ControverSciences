class AddMarkdownToUserDetails < ActiveRecord::Migration
  def change
    add_column :user_details, :content_markdown, :text, default: ""
  end
end
