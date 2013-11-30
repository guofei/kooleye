class AddTokenToThing < ActiveRecord::Migration
  def change
    add_column :things, :token, :string
  end
end
