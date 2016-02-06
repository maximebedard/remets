class CreateSubmission < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :user_id
      t.uuid :handover_id
      t.timestamp
    end
  end
end
