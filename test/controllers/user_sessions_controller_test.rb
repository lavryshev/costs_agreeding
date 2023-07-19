require "test_helper"

class UserSessionsControllerTest < ActionDispatch::IntegrationTest

  test 'should redirect to login page for not authenticated users if there are no users in the application' do
    get root_path
    assert_redirected_to new_user_session_path
  end

  test "should logout" do
    login(users(:user1))
    delete user_session_url
    assert_redirected_to new_user_session_url
    assert_not_logged_in
  end

end