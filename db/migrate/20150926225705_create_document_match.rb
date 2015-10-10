class CreateDocumentMatch < ActiveRecord::Migration
  def change
    create_table :document_matches do |t|
      t.integer :reference_document_id
      t.integer :compared_document_id
      t.integer :matching_fingerprints, array: true, default: []
    end
  end
end
