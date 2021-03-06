class CreateSubscription < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id, null: false
      t.integer :evaluation_id, null: false
    end

    add_index :subscriptions, [:user_id, :evaluation_id], unique: true
  end
end
