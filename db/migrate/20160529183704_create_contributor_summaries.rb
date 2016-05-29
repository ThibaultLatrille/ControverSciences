class CreateContributorSummaries < ActiveRecord::Migration
  def change
    create_table :contributor_summaries do |t|
      t.references :summary, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
