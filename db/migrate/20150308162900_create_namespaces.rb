class CreateNamespaces < ActiveRecord::Migration
  def change
    create_table :namespaces do |t|
      t.references :ownerable, polymorphic: true, null: false, index: true
      t.string :path, null: false, index: { unique: true }
      t.timestamps null: false
    end
  end
end
