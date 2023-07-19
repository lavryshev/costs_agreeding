require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to registration page for not authenticated users if there are no users in the application' do
    User.delete_all
    get root_path
    assert_redirected_to registration_path
  end

  test 'should be created admin user after registration' do
    User.delete_all
    post register_url, params: { user: { name: 'Admisitrator', email: 'admin@test.com', login: 'admin', password: '1', password_confirmation: '1' } }
    assert User.last.is_admin
  end

  test "shouldn't get index for not authenticated user" do
    get users_url
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get index for not admin user" do
    login(users(:user1))
    get users_url
    assert_redirected_to permission_error_path
  end

  test "should get index for admin" do
    login(users(:admin))
    get users_url
    assert_response :success
  end

  test "shouldn't get new for not authenticated user" do
    get new_user_url
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get new for not admin user" do
    login(users(:user1))
    get new_user_url
    assert_redirected_to permission_error_path
  end

  test "should get new for admin" do
    login(users(:admin))
    get new_user_url
    assert_response :success
  end

  test "shouldn't create user for not authenticated user" do
    assert_no_difference("User.count") do
      post users_url, params: { user: { name: 'New User', email: 'newuser@test.com', login: 'new_user', password: '1', password_confirmation: '1' } }
    end
    assert_redirected_to new_user_session_path
  end

  test "shouldn't create new user for not admin user" do
    login(users(:user1))
    assert_no_difference("User.count") do
      post users_url, params: { user: { name: 'New User', email: 'newuser@test.com', login: 'new_user', password: '1', password_confirmation: '1' } }
    end
    assert_redirected_to permission_error_path
  end

  test "should create new user for admin" do
    login(users(:admin))
    assert_difference("User.count") do
      post users_url, params: { user: { name: 'New User', email: 'newuser@test.com', login: 'newuser', password: '1', password_confirmation: '1' } }
    end
    assert_redirected_to users_url
  end

  test "shouldn't get edit for not authenticated user" do
    @user2 = users(:user2)
    get edit_user_url(@user2)
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get edit for not admin user" do
    login(users(:user1))
    @user2 = users(:user2)
    get edit_user_url(@user2)
    assert_redirected_to permission_error_path
  end

  test "should get edit for admin" do
    login(users(:admin))
    @user2 = users(:user2)
    get edit_user_url(@user2)
    assert_response :success
  end

  test "shouldn't update user for not authenticated user" do
    @user2 = users(:user2)
    patch user_url(@user2), params: { user: { name: "New Name" } }
    assert_redirected_to new_user_session_path
  end

  test "shouldn't update user for not admin user" do
    login(users(:user1))
    @user2 = users(:user2)
    patch user_url(@user2), params: { user: { name: "New Name" } }
    assert_redirected_to permission_error_path
  end

  test "should update user for admin" do
    login(users(:admin))
    @user2 = users(:user2)
    patch user_url(@user2), params: { user: { name: "New Name" } }
    assert_redirected_to users_url
  end

  test "shouldn't set is_admin=false for the last admin user" do
    @admin = users(:admin)
    post users_url(@admin), params: { user: { is_admin: false } }
    @admin.reload
    assert @admin.is_admin
  end

  test "shouldn't destroy user for not authenticated user" do
    @user2 = users(:user2)
    assert_no_difference("User.count", -1) do
      delete user_url(@user2)
    end
    assert_redirected_to new_user_session_path
  end

  test "shouldn't destroy user for not admin user" do
    login(users(:user1))
    @user2 = users(:user2)
    assert_no_difference("User.count", -1) do
      delete user_url(@user2)
    end
    assert_redirected_to permission_error_path
  end

  test "should destroy user for admin" do
    login(users(:admin))
    @user2 = users(:user2)
    assert_difference("User.count", -1) do
      delete user_url(@user2)
    end
    assert_redirected_to users_url
  end
end
