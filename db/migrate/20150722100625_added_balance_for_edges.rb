class AddedBalanceForEdges < ActiveRecord::Migration
  def change
    add_column :reference_edges, :plus, :integer, default: 0
    add_column :reference_edges, :minus, :integer, default: 0
    add_column :reference_edges, :balance, :integer, default: 0
    add_column :edges, :plus, :integer, default: 0
    add_column :edges, :minus, :integer, default: 0
    add_column :edges, :balance, :integer, default: 0
  end
end
