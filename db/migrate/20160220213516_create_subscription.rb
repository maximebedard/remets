class CreateSubscription < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id, null: false
      t.integer :handover_id, null: false
    end

    add_index :subscriptions, [:user_id, :handover_id], unique: true
  end
end
