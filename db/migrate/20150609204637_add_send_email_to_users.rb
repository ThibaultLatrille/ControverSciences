class AddSendEmailToUsers < ActiveRecord::Migration
  def change
    add_column :user_details, :send_email, :boolean, default: true
  end
end