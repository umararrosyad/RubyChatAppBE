# Hapus data lama dulu (dari yang tergantung ke utama)
RoomUser.delete_all
Message.delete_all
Room.delete_all
User.delete_all

# Buat beberapa user tanpa set id
users_data = [
  { nickname: "Alice" },
  { nickname: "Bob" },
  { nickname: "Charlie" }
]

users = users_data.map { |attrs| User.create!(attrs) }

# Buat beberapa room tanpa set id
rooms_data = [
  { name: "General Chat" },
  { name: "Tech Talk" }
]

rooms = rooms_data.map { |attrs| Room.create!(attrs) }

# Assign user ke room (room_users) tanpa set id
rooms.each do |room|
  users.each do |user|
    RoomUser.create!(
      room_id: room.id,
      user_id: user.id,
      joined_at: Time.current
    )
  end
end

puts "Seeded #{User.count} users, #{Room.count} rooms, #{RoomUser.count} room_users"
