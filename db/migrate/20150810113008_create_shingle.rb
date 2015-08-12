class CreateShingle < ActiveRecord::Migration
  def change
    create_table :shingles do |t|
      t.string :signature
    end
  end
end
