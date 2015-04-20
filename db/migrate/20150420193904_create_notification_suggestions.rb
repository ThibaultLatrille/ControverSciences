class CreateNotificationSuggestions < ActiveRecord::Migration
  def change
    create_table :notification_suggestions do |t|
      t.references :user, index: true
      t.references :suggestion_child, index: true
      t.references :suggestion, index: true

      t.timestamps
    end
  end
end
