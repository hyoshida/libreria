class CreateOptionTypes < ActiveRecord::Migration
  def change
    create_table :option_types do |t|
      t.string :name, null: false, index: { unique: true }
      t.timestamps null: false
    end
  end
end
