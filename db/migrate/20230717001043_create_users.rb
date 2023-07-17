class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username, index: { unique: true, name: 'users_username_unique' }
      t.string :password_digest
      t.uuid :password_reset_token
      t.datetime :password_reset_sent_on
      t.datetime :password_last_update
      t.integer :password_tries
      t.boolean :blocked

      t.timestamps
    end
  end
end
