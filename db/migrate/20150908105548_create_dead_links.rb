class CreateDeadLinks < ActiveRecord::Migration
  def change
    create_table :dead_links do |t|
      t.references :reference, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
