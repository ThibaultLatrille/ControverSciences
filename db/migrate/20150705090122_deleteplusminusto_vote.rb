class DeleteplusminustoVote < ActiveRecord::Migration
  def change
    remove_column :edges, :plus
    remove_column :edges, :minus
  end
end
