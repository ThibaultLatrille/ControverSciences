class AddContentToBestComment < ActiveRecord::Migration
  def change
    add_column :best_comments, :f_0_comment_id, :integer
    add_column :best_comments, :f_1_comment_id, :integer
    add_column :best_comments, :f_2_comment_id, :integer
    add_column :best_comments, :f_3_comment_id, :integer
    add_column :best_comments, :f_4_comment_id, :integer
    add_column :best_comments, :f_5_comment_id, :integer
    add_column :best_comments, :f_6_comment_id, :integer
    add_column :best_comments, :f_7_comment_id, :integer
    add_column :best_comments, :f_0_user_id, :integer
    add_column :best_comments, :f_1_user_id, :integer
    add_column :best_comments, :f_2_user_id, :integer
    add_column :best_comments, :f_3_user_id, :integer
    add_column :best_comments, :f_4_user_id, :integer
    add_column :best_comments, :f_5_user_id, :integer
    add_column :best_comments, :f_6_user_id, :integer
    add_column :best_comments, :f_7_user_id, :integer
    remove_column :best_comments, :user_id
    remove_column :best_comments, :comment_id
    add_column :votes, :field, :integer
    add_column :comments, :f_0_balance, :integer, default: 0
    add_column :comments, :f_1_balance, :integer, default: 0
    add_column :comments, :f_2_balance, :integer, default: 0
    add_column :comments, :f_3_balance, :integer, default: 0
    add_column :comments, :f_4_balance, :integer, default: 0
    add_column :comments, :f_5_balance, :integer, default: 0
    add_column :comments, :f_6_balance, :integer, default: 0
    add_column :comments, :f_7_balance, :integer, default: 0
    add_column :comments, :f_0_score, :float, default: 0.0
    add_column :comments, :f_1_score, :float, default: 0.0
    add_column :comments, :f_2_score, :float, default: 0.0
    add_column :comments, :f_3_score, :float, default: 0.0
    add_column :comments, :f_4_score, :float, default: 0.0
    add_column :comments, :f_5_score, :float, default: 0.0
    add_column :comments, :f_6_score, :float, default: 0.0
    add_column :comments, :f_7_score, :float, default: 0.0
    remove_column :comments, :balance
    remove_column :comments, :score
    remove_column :comments, :best
    add_column :new_comment_selections, :field, :integer
    add_column :notification_selection_wins, :field, :integer
    add_column :notification_selection_losses, :field, :integer
    add_column :notification_selections, :field, :integer
  end
end
