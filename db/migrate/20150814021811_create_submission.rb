class CreateSubmission < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :user_id
      t.integer :evaluation_id
      t.timestamps null: false
    end

    add_index :submissions, :user_id
    add_index :submissions, :evaluation_id
  end
end
