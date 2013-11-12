class AddVotesToThing < ActiveRecord::Migration
  def change
    add_column :things, :votes, :integer
  end
end
