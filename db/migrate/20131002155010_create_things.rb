class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.string :name
      t.string :summary
      t.text :introduction

      t.timestamps
    end
  end
end
