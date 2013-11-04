class AddVideoToThings < ActiveRecord::Migration
  def change
    add_column :things, :video, :string
  end
end
