class AddCountToLinks < ActiveRecord::Migration
  def change
    add_column :summary_links, :count, :integer
    add_column :links, :count, :integer
  end
end
