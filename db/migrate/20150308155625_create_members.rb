class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :organization, null: false
      t.references :user, null: false
      t.string :role, null: false
      t.timestamps null: false
    end
  end
end
