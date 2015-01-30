class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.text :doi
      t.text :url
      t.integer :year
      t.text :title
      t.text :title_fr
      t.text :author
      t.text :journal
      t.text :publisher
      t.boolean :open_access, default: true
      t.text :abstract, default: ""
      t.integer :nb_contributors, default: 0
      t.integer :nb_edits, default: 0
      t.integer :nb_votes, default: 0
      t.integer :star_1, default: 0
      t.integer :star_2, default: 0
      t.integer :star_3, default: 0
      t.integer :star_4, default: 0
      t.integer :star_5, default: 0
      t.integer :star_most, default: 0
      t.integer :binary_1, default: 0
      t.integer :binary_2, default: 0
      t.integer :binary_3, default: 0
      t.integer :binary_4, default: 0
      t.integer :binary_5, default: 0
      t.integer :binary_most, default: 0

      t.timestamps
    end
  end
end
