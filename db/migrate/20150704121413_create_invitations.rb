class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :user, index: true
      t.text :message
      t.references :timeline, index: true
      t.references :reference, index: true
      t.text :target_email
      t.text :target_name
      t.text :user_name

      t.timestamps
    end
  end
end
