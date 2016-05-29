class CreateContributorFrames < ActiveRecord::Migration
  def change
    create_table :contributor_frames do |t|
      t.references :frame, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
