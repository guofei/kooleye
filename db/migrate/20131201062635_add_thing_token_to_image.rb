class AddThingTokenToImage < ActiveRecord::Migration
  def change
    add_column :images, :thing_token, :string
  end
end
