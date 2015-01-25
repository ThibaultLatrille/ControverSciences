class CreateNewSummaries < ActiveRecord::Migration
  def change
    create_table :new_summaries do |t|
      t.references :summary, index: true

      t.timestamps
    end
  end
end
