class CreateAuthorization < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.integer :user_id
      t.string :provider
      t.string :email
      t.string :name
      t.string :uid
      t.string :token
      t.string :refresh_token
      t.string :secret
      t.datetime :expires_at
      t.timestamps null: false
    end
  end
end
