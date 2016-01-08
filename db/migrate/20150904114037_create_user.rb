class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :provider
      t.string :name
      t.string :email, unique: true, null: false
      t.string :role, default: "user", null: false
    end
  end
end
