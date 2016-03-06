class CreateTimelineChoices < ActiveRecord::Migration
  def change
    create_table :timeline_choices do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.integer :choices, array: true, default: []

      t.timestamps
    end
  end
end
