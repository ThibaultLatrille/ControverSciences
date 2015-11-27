class AddATagPairs < ActiveRecord::Migration
  def change
    create_table :tag_pairs do |t|
      t.integer :tag_theme_source
      t.integer :tag_theme_target
      t.boolean :references
      t.integer :occurencies

      t.timestamps
    end

  end
end
