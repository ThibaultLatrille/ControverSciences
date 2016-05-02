class AddedMarkdownForMessages < ActiveRecord::Migration
  def change
    add_column :patch_messages, :message_markdown, :text, default: ''
  end
end
