class CreateNotificationTypos < ActiveRecord::Migration
  def change
    create_table :notification_typos do |t|
      t.references :user, index: true
      t.references :typo, index: true

      t.timestamps
    end
  end
end
