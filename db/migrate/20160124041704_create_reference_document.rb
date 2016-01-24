class CreateReferenceDocument < ActiveRecord::Migration
  def change
    create_table :reference_documents do |t|
      t.references :handover
      t.string :file_ptr
      t.string :file_secure_token
      t.string :file_original_name
      t.timestamps null: false
    end
  end
end
