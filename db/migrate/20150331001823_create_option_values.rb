class CreateOptionValues < ActiveRecord::Migration
  def change
    create_table :option_values do |t|
      t.references :option_type, null: false
      t.string :name, null: false
      t.timestamps null: false

      t.index [:option_type_id, :name], unique: true
    end
  end
end
