class RenameLikeToVote < ActiveRecord::Migration
  def change
    rename_table :likes, :votes
  end
end
