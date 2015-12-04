class AddedFirstandLastName < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :text, default: ""
    add_column :users, :last_name, :text, default: ""
  end
end
