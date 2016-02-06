require SecureRandom
class CreateHandover < ActiveRecord::Migration
  def change
    create_table :handovers do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.timestamps null: false
      t.uuid :uuid, unique: true
      t.boolean :invite_only, default: true
      t.string :password, null: true
    end
  end
end
