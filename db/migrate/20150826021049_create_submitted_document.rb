class CreateSubmittedDocument < ActiveRecord::Migration
  def change
    create_table :submitted_documents do |t|
      t.integer :submission_id
      t.string :file_ptr
      t.string :file_secure_token
      t.string :file_original_name
      t.integer :fingerprints, array: true, default: [], null: false
      t.integer :indexes, array: true, default: [], null: false
      t.datetime :fingerprinted_at
      t.timestamps null: false
    end

    add_index :submitted_documents, :fingerprints, using: "gin"
  end
end
