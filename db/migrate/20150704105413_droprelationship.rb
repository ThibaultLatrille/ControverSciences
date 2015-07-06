class Droprelationship < ActiveRecord::Migration
  def change
    drop_table :summary_relationships
    drop_table :comment_relationships
  end
end
