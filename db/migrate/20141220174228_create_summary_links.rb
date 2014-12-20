class CreateSummaryLinks < ActiveRecord::Migration
  def change
    create_table :summary_links do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.references :reference, index: true
      t.references :summary, index: true

      t.timestamps
    end
  end
end
