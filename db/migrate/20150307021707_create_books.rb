class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :amazon_item_id, null: false, index: { unique: true }
      # t.integer :namespace_id, null: false
      t.string :state, null: false
      t.string :location_name
      t.datetime :arrived_at
      t.timestamps null: false
    end
  end
end
