class CreateNewSummarySelections < ActiveRecord::Migration
  def change
    create_table :new_summary_selections do |t|
      t.integer :old_summary
      t.integer :new_summary

      t.timestamps
    end
  end
end
