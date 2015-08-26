class CreateDocument < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :submission
      t.string :file
      t.string :signature
      t.integer :shingles, array: true
    end
  end
end
