class CreateDocumentMatch < ActiveRecord::Migration
  def change
    create_table :document_matches do |t|
      t.integer :reference_document_id
      t.integer :compared_document_id
      t.integer :match_id
      t.float :similarity
      t.timestamps null: false
    end
  end
end
