class CreateContributorComments < ActiveRecord::Migration
  def change
    create_table :contributor_comments do |t|
      t.references :comment, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
