class CreateFrameCredits < ActiveRecord::Migration
  def change
    create_table :frame_credits do |t|
      t.references :timeline, index: true
      t.references :user, index: true
      t.references :frame, index: true
      t.integer :value

      t.timestamps
    end
  end
end
