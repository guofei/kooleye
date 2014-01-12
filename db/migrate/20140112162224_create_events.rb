class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :content
      t.string :summary
      t.integer :day

      t.timestamps
    end
  end
end
