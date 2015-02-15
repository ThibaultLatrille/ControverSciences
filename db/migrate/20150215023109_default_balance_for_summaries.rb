class DefaultBalanceForSummaries < ActiveRecord::Migration
  def change
    change_column_default :summaries, :balance, 0
  end
end
