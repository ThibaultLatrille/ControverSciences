class AddplusminustoVote < ActiveRecord::Migration
  def change
    add_column :edges, :plus, :integer, default: 0
    add_column :edges, :minus, :integer, default: 0
  end
end
