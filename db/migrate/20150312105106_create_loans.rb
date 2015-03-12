class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.references :book, null: false
      t.references :user, null: false
      t.datetime :returned_at
      t.index [:book_id, :user_id, :returned_at], unique: true
      t.timestamps null: false
    end
  end
end
