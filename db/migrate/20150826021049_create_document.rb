class CreateDocument < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :documentable, polymorphic: true, index: true
      t.string :file_ptr
      t.string :file_secure_token
      t.string :file_original_name
      t.integer :fingerprints, array: true, default: [], null: false
      t.integer :indexes, array: true, default: [], null: false
      t.datetime :fingerprinted_at
      t.timestamps
    end

    add_index :documents, :fingerprints, using: "gin"
  end
end
