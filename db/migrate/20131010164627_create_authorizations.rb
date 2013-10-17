class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.references :user, index: true
      t.string :uid

      t.timestamps
    end
  end
end
