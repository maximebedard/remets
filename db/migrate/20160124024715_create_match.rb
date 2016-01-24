class CreateMatch < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :fingerprints, array: true, default: [], null: false
      t.timestamps null: false
    end
  end
end
