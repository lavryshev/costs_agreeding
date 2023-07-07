require "test_helper"

class BankAccountsControllerTest < ActionDispatch::IntegrationTest

  test "shouldn't get index for not authenticated user" do
    get bank_accounts_url
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get index for not admin user" do
    login(users(:user1))
    get bank_accounts_url
    assert_redirected_to permission_error_path
  end

  test "should get index for admin" do
    login(users(:admin))
    get bank_accounts_url
    assert_response :success
  end

  test "shouldn't get new bank account for not authenticated user" do
    get new_bank_account_url
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get new bank account for not admin user" do
    login(users(:user1))
    get new_bank_account_url
    assert_redirected_to permission_error_path
  end

  test "should get new bank account for admin" do
    login(users(:admin))
    get new_bank_account_url
    assert_response :success
  end

  test "shouldn't create bank account for not authenticated user" do
    assert_no_difference("BankAccount.count") do
      post bank_accounts_url, params: { bank_account: { name: 'Основной в Банк2' } }
    end
    assert_redirected_to new_user_session_path
  end

  test "shouldn't create new bank account for not admin user" do
    login(users(:user1))
    assert_no_difference("BankAccount.count") do
      post bank_accounts_url, params: { bank_account: { name: 'Основной в Банк2' } }
    end
    assert_redirected_to permission_error_path
  end

  test "should create new bank account for admin" do
    login(users(:admin))
    assert_difference("BankAccount.count") do
      post bank_accounts_url, params: { bank_account: { name: 'Основной в Банк2' } }
    end
    assert_redirected_to bank_accounts_url
  end

  test "shouldn't get edit bank account for not authenticated user" do
    @bank_account = bank_accounts(:first)
    get edit_bank_account_url(@bank_account)
    assert_redirected_to new_user_session_path
  end

  test "shouldn't get edit bank account for not admin user" do
    login(users(:user1))
    @bank_account = bank_accounts(:first)
    get edit_bank_account_url(@bank_account)
    assert_redirected_to permission_error_path
  end

  test "should get edit bank account for admin" do
    login(users(:admin))
    @bank_account = bank_accounts(:first)
    get edit_bank_account_url(@bank_account)
    assert_response :success
  end

  test "shouldn't update bank account for not authenticated user" do
    @bank_account = bank_accounts(:first)
    patch bank_account_url(@bank_account), params: { bank_account: { name: "Основной в Банк2" } }
    assert_redirected_to new_user_session_path
  end

  test "shouldn't update bank account for not admin user" do
    login(users(:user1))
    @bank_account = bank_accounts(:first)
    patch bank_account_url(@bank_account), params: { bank_account: { name: "Основной в Банк2" } }
    assert_redirected_to permission_error_path
  end

  test "should update bank account for admin" do
    login(users(:admin))
    @bank_account = bank_accounts(:first)
    patch bank_account_url(@bank_account), params: { bank_account: { name: "Основной в Банк2" } }
    assert_redirected_to bank_accounts_url
  end

  test "shouldn't destroy bank account for not authenticated user" do
    @bank_account = bank_accounts(:first)
    assert_no_difference("BankAccount.count", -1) do
      delete bank_account_url(@bank_account)
    end
    assert_redirected_to new_user_session_path
  end

  test "shouldn't destroy bank account for not admin user" do
    login(users(:user1))
    @bank_account = bank_accounts(:first)
    assert_no_difference("BankAccount.count", -1) do
      delete bank_account_url(@bank_account)
    end
    assert_redirected_to permission_error_path
  end

  test "should destroy bank account for admin" do
    login(users(:admin))
    @bank_account = bank_accounts(:first)
    assert_difference("BankAccount.count", -1) do
      delete bank_account_url(@bank_account)
    end
    assert_redirected_to bank_accounts_url
  end

end
