class CreateHelpfulnesses < ActiveRecord::Migration
  def change
    create_table :helpfulnesses do |t|
      t.references :comment, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
