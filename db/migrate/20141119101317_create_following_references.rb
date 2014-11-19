class CreateFollowingReferences < ActiveRecord::Migration
  def change
    create_table :following_references do |t|
      t.references :user, index: true
      t.references :reference, index: true

      t.timestamps
    end
  end
end
