class CreateHandover < ActiveRecord::Migration
  def change
    enable_extension "uuid-ossp"

    create_table :handovers, id: false do |t|
      t.primary_key :id, :uuid, default: "uuid_generate_v4()"
      t.integer :user_id
      t.string :title
      t.text :description
      t.timestamps null: false
      t.boolean :invite_only, default: true
      t.string :password, null: true
    end
  end
end
