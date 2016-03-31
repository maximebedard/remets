class CreateHandover < ActiveRecord::Migration
  def change
    create_table :handovers do |t|
      t.uuid :uuid, null: false
      t.integer :user_id
      t.integer :organization_id
      t.string :title
      t.text :description
      t.datetime :mark_as_completed
      t.timestamps null: false
      t.datetime :due_date, null: false
      t.boolean :invite_only, null: false, default: true
      t.string :password_digest, null: true
    end
  end
end
