class CreateRoomUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :room_users do |t|
      t.uuid :room_id, null: false
      t.uuid :user_id, null: false
      t.timestamp :joined_at

      t.timestamps
    end

    add_foreign_key :room_users, :rooms
    add_foreign_key :room_users, :users
  end
end