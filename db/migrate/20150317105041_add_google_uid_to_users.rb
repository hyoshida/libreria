class AddGoogleUidToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :google_uid
    end
  end
end
