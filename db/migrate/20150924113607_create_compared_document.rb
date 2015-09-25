class CreateComparedDocument < ActiveRecord::Migration
  def change
    create_table :compared_documents do |t|
      t.integer :document1_id
      t.integer :document2_id
      t.integer :indexes, array: true, default: []
      t.integer :fingerprints, array: true, default: []
    end
  end
end
