class CreateDocument < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string    :signature
      t.string    :url
      t.text      :text
      t.timestamp
    end
  end
end
