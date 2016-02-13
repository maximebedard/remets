class CreateHandover < ActiveRecord::Migration
  def change
    enable_extension "uuid-ossp"

    create_table :handovers do |t|
      t.uuid :uuid, null: false
      t.integer :user_id
      t.string :title
      t.text :description
      t.timestamps null: false
      t.boolean :invite_only, default: true
      t.string :password_digest, null: true
    end
  end
end
