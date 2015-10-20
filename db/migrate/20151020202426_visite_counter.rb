class VisiteCounter < ActiveRecord::Migration
  def change
    add_column :visite_references, :counter, :integer, :default => 0
    add_column :visite_timelines, :counter, :integer, :default => 0
  end
end
