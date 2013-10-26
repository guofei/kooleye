class AddThingToImage < ActiveRecord::Migration
  def change
    add_reference :images, :thing, index: true
  end
end
