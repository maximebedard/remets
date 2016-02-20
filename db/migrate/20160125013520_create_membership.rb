class CreateMembership < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id, null: false
      t.integer :organization_id, null: false
    end

    add_index :memberships, [:user_id, :organization_id], unique: true
  end
end
