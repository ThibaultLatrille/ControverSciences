class CreateNewSummarySelections < ActiveRecord::Migration
  def change
    create_table :new_summary_selections do |t|
      t.integer :old_summary_id
      t.integer :new_summary_id

      t.timestamps
    end
  end
end
