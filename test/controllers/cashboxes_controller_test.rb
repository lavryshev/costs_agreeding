require "test_helper"

class CashboxesControllerTest < ActionDispatch::IntegrationTest

  test "shouldn't get index for not authenticated user" do
    get cashboxes_url
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get index for not admin user" do
    login(users(:user1))
    get cashboxes_url
    assert_redirected_to permission_error_path
  end

  test "should get index for admin" do
    login(users(:admin))
    get cashboxes_url
    assert_response :success
  end

  test "shouldn't get new cashbox for not authenticated user" do
    get new_cashbox_url
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get new cashbox for not admin user" do
    login(users(:user1))
    get new_cashbox_url
    assert_redirected_to permission_error_path
  end

  test "should get new cashbox for admin" do
    login(users(:admin))
    get new_cashbox_url
    assert_response :success
  end

  test "shouldn't create cashbox for not authenticated user" do
    assert_no_difference("Cashbox.count") do
      post cashboxes_url, params: { cashbox: { name: 'Касса грн' } }
    end
    assert_redirected_to new_user_session_path
  end

  test "shouldn't create new cashbox for not admin user" do
    login(users(:user1))
    assert_no_difference("Cashbox.count") do
      post cashboxes_url, params: { cashbox: { name: 'Касса грн' } }
    end
    assert_redirected_to permission_error_path
  end

  test "should create new cashbox for admin" do
    login(users(:admin))
    assert_difference("Cashbox.count") do
      post cashboxes_url, params: { cashbox: { name: 'Касса грн' } }
    end
    assert_redirected_to cashboxes_url
  end

  test "shouldn't get edit cashbox for not authenticated user" do
    @cashbox = cashboxes(:uah)
    get edit_cashbox_url(@cashbox)
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get edit cashbox for not admin user" do
    login(users(:user1))
    @cashbox = cashboxes(:uah)
    get edit_cashbox_url(@cashbox)
    assert_redirected_to permission_error_path
  end

  test "should get edit cashbox for admin" do
    login(users(:admin))
    @cashbox = cashboxes(:uah)
    get edit_cashbox_url(@cashbox)
    assert_response :success
  end

  test "shouldn't update cashbox for not authenticated user" do
    @cashbox = cashboxes(:uah)
    patch cashbox_url(@cashbox), params: { cashbox: { name: "Касса грн." } }
    assert_redirected_to new_user_session_path
  end

  test "shouldn't update cashbox for not admin user" do
    login(users(:user1))
    @cashbox = cashboxes(:uah)
    patch cashbox_url(@cashbox), params: { cashbox: { name: "Касса грн." } }
    assert_redirected_to permission_error_path
  end

  test "should update cashbox for admin" do
    login(users(:admin))
    @cashbox = cashboxes(:uah)
    patch cashbox_url(@cashbox), params: { cashbox: { name: "Касса грн." } }
    assert_redirected_to cashboxes_url
  end

  test "shouldn't destroy cashbox for not authenticated user" do
    @cashbox = cashboxes(:uah)
    assert_no_difference("Cashbox.count", -1) do
      delete cashbox_url(@cashbox)
    end
    assert_redirected_to new_user_session_path
  end

  test "shouldn't destroy cashbox for not admin user" do
    login(users(:user1))
    @cashbox = cashboxes(:uah)
    assert_no_difference("Cashbox.count", -1) do
      delete cashbox_url(@cashbox)
    end
    assert_redirected_to permission_error_path
  end

  test "should destroy cashbox for admin" do
    login(users(:admin))
    @cashbox = cashboxes(:uah)
    assert_difference("Cashbox.count", -1) do
      delete cashbox_url(@cashbox)
    end
    assert_redirected_to cashboxes_url
  end

end
