class CreateTimelineContributors < ActiveRecord::Migration
  def change
    create_table :timeline_contributors do |t|
      t.references :user, index: true
      t.references :timeline, index: true
      t.boolean :bool

      t.timestamps
    end
  end
end
