class CreateSubmission < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :document
      t.string :document_signature
      t.integer :shingles, array: true
      t.timestamp
    end
  end
end
