class CreateRoomUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :room_users do |t|
      # Hapus t.primary_key :id - sudah otomatis dibuat
      t.integer :room_id, null: false  # Ganti dari uuid ke integer
      t.integer :user_id, null: false  # Ganti dari uuid ke integer
      t.timestamp :joined_at

      t.timestamps
    end

    # Tambahkan index untuk performa dan foreign key constraints
    add_index :room_users, :room_id
    add_index :room_users, :user_id
    add_index :room_users, [:room_id, :user_id], unique: true  # Prevent duplicate entries
    
    add_foreign_key :room_users, :rooms
    add_foreign_key :room_users, :users
  end
end