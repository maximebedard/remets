class CreateHandover < ActiveRecord::Migration
  def change
    create_table :handovers do |t|
      t.references :user
      t.timestamps
    end
  end
end
