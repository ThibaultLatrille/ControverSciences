class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :user, index: true
      t.text :title
      t.text :title_markdown
      t.text :content
      t.text :content_markdown

      t.timestamps
    end
  end
end
