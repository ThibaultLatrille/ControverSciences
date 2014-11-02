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
      t.text :abstract, default: ""
      t.integer :nb_contributors, default: 0
      t.integer :nb_edits, default: 0
      t.integer :nb_votes, default: 0
      t.integer :star_1, default: 0
      t.integer :star_2, default: 0
      t.integer :star_3, default: 0
      t.integer :star_4, default: 0
      t.integer :star_5, default: 0
      t.integer :f_1_id
      t.text :f_1_content
      t.integer :f_1_votes_plus
      t.integer :f_1_votes_minus
      t.integer :f_2_id
      t.text :f_2_content
      t.integer :f_2_votes_plus
      t.integer :f_2_votes_minus
      t.integer :f_3_id
      t.text :f_3_content
      t.integer :f_3_votes_plus
      t.integer :f_3_votes_minus
      t.integer :f_4_id
      t.text :f_4_content
      t.integer :f_4_votes_plus
      t.integer :f_4_votes_minus
      t.integer :f_5_id
      t.text :f_5_content
      t.integer :f_5_votes_plus
      t.integer :f_5_votes_minus

      t.timestamps
    end
  end
end
