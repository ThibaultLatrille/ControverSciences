class AddPictureToSummaries < ActiveRecord::Migration
  def change
    add_column :summaries, :picture, :string
    add_column :summaries, :caption, :text
    add_column :summaries, :caption_markdown, :text
  end
end
