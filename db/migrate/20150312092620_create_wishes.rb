class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.references :book, null: false
      t.references :user, null: false
      t.index [:book_id, :user_id], unique: true
      t.timestamps null: false
    end
  end
end
