require "test_helper"

class RoomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(nickname: "Tester")
    @user2 = User.create!(nickname: "Second")
    @room = Room.create!(name: "Test Room")
    RoomUser.create!(user_id: @user.id, room_id: @room.id, joined_at: Time.current)
  end

  test "should get joined rooms" do
    get "/api/v1/rooms", params: { user_id: @user.id }
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json.length
  end

  test "should show room" do
    get "/api/v1/rooms/#{@room.id}"
    assert_response :success
  end

  test "should create room and join multiple users" do
    assert_difference(["Room.count", "RoomUser.count"], 2) do
      post "/api/v1/rooms", params: {
        name: "Group Room",
        user_ids: [@user.id, @user2.id]
      }
    end
    assert_response :created
  end

  test "should not create room with less than 2 users" do
    assert_no_difference(["Room.count", "RoomUser.count"]) do
      post "/api/v1/rooms", params: {
        name: "Invalid Room",
        user_ids: [@user.id]
      }
    end
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "Minimal dua user harus bergabung ke room", json["error"]
  end

  test "should join multiple users to existing room" do
    post "/api/v1/rooms/#{@room.id}/join", params: {
      user_ids: [@user.id, @user2.id]
    }
    assert_response :success
    assert_equal 2, RoomUser.where(room_id: @room.id).count
  end

  test "should get room messages" do
    Message.create!(room_id: @room.id, user_id: @user.id, content: "Hello")
    get "/api/v1/rooms/#{@room.id}/messages"
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json.length
  end

  test "should get room users" do
    get "/api/v1/rooms/#{@room.id}/users"
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json.length
  end
end
