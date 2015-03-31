class CreateBooksOptionValues < ActiveRecord::Migration
  def change
    create_table :books_option_values do |t|
      t.references :book, null: false
      t.references :option_value, null: false
      t.timestamps null: false

      t.index [:book_id, :option_value_id], unique: true
    end
  end
end
