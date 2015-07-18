class AddSlugToTimelines < ActiveRecord::Migration
  def change
    add_column :timelines, :slug, :string
    add_index :timelines, :slug, unique: true
  end
end
