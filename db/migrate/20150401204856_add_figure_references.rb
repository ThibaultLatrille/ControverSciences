class AddFigureReferences < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.references :figure, index: true
    end
    change_table :summaries do |t|
      t.references :figure, index: true
    end
    change_table :user_details do |t|
      t.references :figure, index: true
    end
  end
end
