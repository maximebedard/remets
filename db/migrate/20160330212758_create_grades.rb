class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.integer :submission_id
      t.integer :result
      t.text :comments
      t.timestamps null: false
    end
  end
end
