class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :organization, null: false
      t.references :user, null: false
      t.string :role, null: false

      t.string :request_token, index: { unique: true }
      t.datetime :request_sent_at
      t.datetime :request_accepted_at
      t.integer :request_acceptor_id

      t.timestamps null: false

      t.index [:organization_id, :user_id], unique: true
    end
  end
end
