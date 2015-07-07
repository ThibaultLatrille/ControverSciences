class RegerenceTags < ActiveRecord::Migration
  def change
    change_table :reference_user_taggings do |t|
      t.belongs_to :reference, index: true
    end
    drop_table :reference_taggings
  end
end
