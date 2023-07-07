require "test_helper"

class ApiUsersControllerTest < ActionDispatch::IntegrationTest
  test "shouldn't get API user index for not authenticated user" do
    get api_users_url
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get API user index for not admin user" do
    login(users(:user1))
    get api_users_url
    assert_redirected_to permission_error_path
  end

  test "should get API user index for admin" do
    login(users(:admin))
    get api_users_url
    assert_response :success
  end

  test "shouldn't get new API user for not authenticated user" do
    get new_api_user_url
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get new API user for not admin user" do
    login(users(:user1))
    get new_api_user_url
    assert_redirected_to permission_error_path
  end

  test "should get new API user for admin" do
    login(users(:admin))
    get new_api_user_url
    assert_response :success
  end

  test "shouldn't create API user for not authenticated user" do
    assert_no_difference("ApiUser.count") do
      post api_users_url, params: { api_user: { name: 'Client', active: true, webhook_url: 'https://foo.bar' } }
    end
    assert_redirected_to new_user_session_path
  end

  test "shouldn't create new API user for not admin user" do
    login(users(:user1))
    assert_no_difference("ApiUser.count") do
      post api_users_url, params: { api_user: { name: 'Client', active: true, webhook_url: 'https://foo.bar' } }
    end
    assert_redirected_to permission_error_path
  end

  test "should create new API user for admin" do
    login(users(:admin))
    assert_difference("ApiUser.count") do
      post api_users_url, params: { api_user: { name: 'Client', active: true, webhook_url: 'https://foo.bar' } }
    end
    assert_redirected_to api_users_url
  end

  test "shouldn't get edit API user for not authenticated user" do
    @api_user = api_users(:not_active)
    get edit_api_user_url(@api_user)
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get edit API user for not admin user" do
    login(users(:user1))
    @api_user = api_users(:not_active)
    get edit_api_user_url(@api_user)
    assert_redirected_to permission_error_path
  end

  test "should get edit API user for admin" do
    login(users(:admin))
    @api_user = api_users(:not_active)
    get edit_api_user_url(@api_user)
    assert_response :success
  end

  test "shouldn't update API user for not authenticated user" do
    @api_user = api_users(:not_active)
    patch api_user_url(@api_user), params: { api_user: { name: "Client app new name" } }
    assert_redirected_to new_user_session_path
  end

  test "shouldn't update API user for not admin user" do
    login(users(:user1))
    @api_user = api_users(:not_active)
    patch api_user_url(@api_user), params: { api_user: { name: "Client app new name" } }
    assert_redirected_to permission_error_path
  end

  test "should update API user for admin" do
    login(users(:admin))
    @api_user = api_users(:not_active)
    patch api_user_url(@api_user), params: { api_user: { name: "Client app new name" } }
    assert_redirected_to api_users_url
  end

  test "shouldn't destroy API user for not admin user" do
    login(users(:user1))
    @api_user = api_users(:not_active)
    assert_no_difference("ApiUser.count", -1) do
      delete api_user_url(@api_user)
    end
    assert_redirected_to permission_error_path
  end

  test "should destroy API user for admin" do
    login(users(:admin))
    @api_user = api_users(:not_active)
    assert_difference("ApiUser.count", -1) do
      delete api_user_url(@api_user)
    end
    assert_redirected_to api_users_url
  end
end