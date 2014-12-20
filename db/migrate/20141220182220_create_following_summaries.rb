class CreateFollowingSummaries < ActiveRecord::Migration
  def change
    create_table :following_summaries do |t|
      t.references :user, index: true
      t.references :timeline, index: true

      t.timestamps
    end
  end
end
