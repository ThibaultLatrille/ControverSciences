class DefaultCaptionForComments < ActiveRecord::Migration
  def change
    change_column_default :comments, :caption, ''
    change_column_default :comments, :caption_markdown, ''
    change_column_default :summaries, :caption, ''
    change_column_default :summaries, :caption_markdown, ''
  end
end
