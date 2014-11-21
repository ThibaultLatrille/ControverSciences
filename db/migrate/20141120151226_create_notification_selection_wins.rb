class CreateNotificationSelectionWins < ActiveRecord::Migration
  def change
    create_table :notification_selection_wins do |t|
      t.references :user, index: true
      t.references :comment, index: true
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
