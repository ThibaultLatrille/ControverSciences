class AddImportantToUsers < ActiveRecord::Migration
  def change
    add_column :users, :important, :integer
  end
end
