class CreateDocument < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :handle
    end
  end
end
