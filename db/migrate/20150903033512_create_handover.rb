class CreateHandover < ActiveRecord::Migration
  def change
    create_table :handovers do |t|
      t.references :user
      t.string :name
      t.timestamps
    end
  end
end
