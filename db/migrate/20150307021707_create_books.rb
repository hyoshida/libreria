class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :asin, null: false, index: { unique: true }
      t.json :item, null: false, default: {}
      t.timestamps null: false
    end
  end
end
