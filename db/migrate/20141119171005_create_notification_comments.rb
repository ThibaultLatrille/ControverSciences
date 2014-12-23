class CreateNotificationComments < ActiveRecord::Migration
  def change
    create_table :notification_comments do |t|
      t.references :user, index: true
      t.references :comment, index: true

      t.timestamps
    end
  end
end
