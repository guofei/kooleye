class AddUserRefToThings < ActiveRecord::Migration
  def change
    add_reference :things, :user, index: true
  end
end
