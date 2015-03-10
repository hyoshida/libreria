class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :published, null: false, default: true
      t.timestamps null: false
    end
  end
end
