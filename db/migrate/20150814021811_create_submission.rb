class CreateSubmission < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :user
      t.timestamp
    end
  end
end
