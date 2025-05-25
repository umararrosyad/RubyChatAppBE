require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get "/api/v1/users"
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post "/api/v1/users", params: { nickname: "TestUser" }
    end
    assert_response :success
  end
end