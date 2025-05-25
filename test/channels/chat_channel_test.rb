require "test_helper"

class ChatChannelTest < ActionCable::Channel::TestCase
  setup do
    @user = User.create!(nickname: "Tester")
    @room = Room.create!(name: "Test Room")
  end

  test "subscribes and streams from correct channel" do
    subscribe(room_id: @room.id)
    assert subscription.confirmed?
    assert_has_stream "chat_room_#{@room.id}"
  end

  test "receives data and broadcasts message" do
    subscribe(room_id: @room.id)
    assert subscription.confirmed?

    # Pastikan jumlah message bertambah 1 setelah receive
    assert_difference "Message.count", 1 do
      perform :receive, { user_id: @user.id, content: "Hello WebSocket!" }
    end

    # Tangkap broadcast dan pastikan payloadnya sesuai
    expected_broadcast = {
      id: Message.last.id,
      content: "Hello WebSocket!",
      user_id: @user.id,
      user_nickname: @user.nickname,
      created_at: Message.last.created_at.strftime("%H:%M")
    }

    assert_broadcast_on("chat_room_#{@room.id}", expected_broadcast)
  end
end