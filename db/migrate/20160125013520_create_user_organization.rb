class CreateUserOrganization < ActiveRecord::Migration
  def change
    create_table :user_organizations do |t|
      t.integer :user_id, null: false
      t.integer :organization_id, null: false
    end
  end
end
