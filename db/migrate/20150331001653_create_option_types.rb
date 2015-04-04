class CreateOptionTypes < ActiveRecord::Migration
  def change
    create_table :option_types do |t|
      t.references :namespace, null: false
      t.string :name, null: false
      t.timestamps null: false

      t.index [:namespace_id, :name], unique: true
    end
  end
end
