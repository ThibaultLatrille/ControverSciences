class RemovedValueFromVote < ActiveRecord::Migration
  def change
    remove_column :credits, :value
    remove_column :votes, :value
    remove_column :frame_credits, :value
  end
end
