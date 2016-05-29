class AddedOrderToMigration < ActiveRecord::Migration
  def change
    add_column :questions, :score, :integer, index: true
  end
end
