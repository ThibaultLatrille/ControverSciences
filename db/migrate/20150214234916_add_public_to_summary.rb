class AddPublicToSummary < ActiveRecord::Migration
  def change
    add_column :summaries, :public, :boolean, default: true
  end
end
