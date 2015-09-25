class CreateDocument < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :submission
      t.string :file
      t.integer :fingerprints, array: true, default: []
      t.integer :indexes, array: true, default: []
    end

    add_index :documents, :fingerprints, using: 'gin'
  end
end
