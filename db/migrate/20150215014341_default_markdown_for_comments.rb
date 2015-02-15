class DefaultMarkdownForComments < ActiveRecord::Migration
  def change
    change_column_default :comments, :markdown_0, ''
    change_column_default :comments, :markdown_1, ''
    change_column_default :comments, :markdown_2, ''
    change_column_default :comments, :markdown_3, ''
    change_column_default :comments, :markdown_4, ''
    change_column_default :comments, :markdown_5, ''
    change_column_default :summaries, :markdown, ''
    change_column_default :summaries, :content, ''
  end
end
