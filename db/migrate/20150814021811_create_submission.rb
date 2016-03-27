class CreateSubmission < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :user_id
      t.integer :handover_id
      t.timestamps null: false
    end

    add_index :submissions, :user_id
    add_index :submissions, :handover_id
  end
end
