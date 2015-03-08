class CreateActiveAdminComments < ActiveRecord::Migration
  def change
    create_table :active_admin_comments do |t|
      t.string :namespace, index: true
      t.text :body
      t.references :resource, polymorphic: true, null: false, index: true
      t.references :author, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
