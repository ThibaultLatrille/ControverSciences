class AddednbPrivateToUser < ActiveRecord::Migration
  def change
    add_column :users, :nb_private, :integer, default: 0
  end
end
