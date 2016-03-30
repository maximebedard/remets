class CreateGradedDocuments < ActiveRecord::Migration
  def change
    create_table :graded_documents do |t|
      t.integer :grade_id
      t.string :file_ptr
      t.string :file_secure_token
      t.string :file_original_name
      t.timestamps null: false
    end
  end
end
