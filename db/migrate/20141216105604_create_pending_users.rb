class CreatePendingUsers < ActiveRecord::Migration
  def change
    create_table :pending_users do |t|
      t.references :user, index: true
      t.text :why

      t.timestamps
    end
  end
end
