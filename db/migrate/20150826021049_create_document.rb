class CreateDocument < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :submission
      t.string :file
      t.integer :fingerprint, array: true, default: []
      t.integer :indexes, array: true, default: []
    end
  end
end
