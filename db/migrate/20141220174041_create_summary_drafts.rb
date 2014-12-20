class CreateSummaryDrafts < ActiveRecord::Migration
  def change
    create_table :summary_drafts do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.integer :parent_id
      t.text :content

      t.timestamps
    end
  end
end
