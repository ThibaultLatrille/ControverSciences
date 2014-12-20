class CreateSummaryBests < ActiveRecord::Migration
  def change
    create_table :summary_bests do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.references :summary, index: true

      t.timestamps
    end
  end
end
