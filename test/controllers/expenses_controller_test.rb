require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest

  test "shouldn't get new expense for not authenticated user" do
    get new_expense_url
    assert_redirected_to new_user_session_path
  end

  test "should get new expense" do
    login(users(:user1))
    get new_expense_url
    assert_response :success
  end

  test "shouldn't create expense for not authenticated user" do
    assert_no_difference("Expense.count") do
      post expenses_url, params: { expense: { sum: 1000.00, source_sgid: bank_accounts(:first).to_signed_global_id } }
    end
    assert_redirected_to new_user_session_path
  end

  test "should create new expense" do
    login(users(:user1))
    assert_difference("Expense.count") do
      post expenses_url, params: { expense: { sum: 1000.00, source_sgid: bank_accounts(:first).to_signed_global_id } }
    end
    assert_redirected_to root_url
  end

  test "shouldn't get edit for not authenticated user" do
    @expense = Expense.create(sum: 1000.00, author: users(:user1), source: bank_accounts(:first), status: expense_statuses(:not_agreed))
    get edit_expense_url(@expense)
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    login(users(:user1))
    @expense = Expense.create(sum: 1000.00, author: users(:user1), source: bank_accounts(:first), status: expense_statuses(:not_agreed))
    get edit_expense_url(@expense)
    assert_response :success
  end

  test "shouldn't update expense for not authenticated user" do
    @expense = Expense.create(sum: 1000.00, author: users(:user1), source: bank_accounts(:first), status: expense_statuses(:not_agreed))
    patch expense_url(@expense), params: { expense: { sum: 200.00 } }
    assert_redirected_to new_user_session_path
  end

  test "should update expense" do
    login(users(:user1))
    @expense = Expense.create(sum: 1000.00, author: users(:user1), source: bank_accounts(:first), status: expense_statuses(:not_agreed))
    patch expense_url(@expense), params: { expense: { sum: 200.00 } }
    assert_redirected_to root_url
  end

  test "should set agreed status" do
    @expense = Expense.create(sum: 1000.00, author: users(:user1), source: bank_accounts(:first), status: expense_statuses(:not_agreed))
    login(users(:user1))
    put expense_agree_path(@expense)
    assert_response :unprocessable_entity
  end

  test "should set rejected status" do
    @expense = Expense.create(sum: 1000.00, author: users(:user1), source: bank_accounts(:first), status: expense_statuses(:not_agreed))
    login(users(:user1))
    put expense_disagree_path(@expense)
    assert_response :unprocessable_entity
  end

  test "shouldn't destroy expense for not authenticated user" do
    @expense = Expense.create(sum: 1000.00, author: users(:user1), source: bank_accounts(:first), status: expense_statuses(:not_agreed))
    assert_no_difference("Expense.count", -1) do
      delete expense_url(@expense)
    end
    assert_redirected_to new_user_session_path
  end

  test "should destroy expense" do
    login(users(:user1))
    @expense = Expense.create(sum: 1000.00, author: users(:user1), source: bank_accounts(:first), status: expense_statuses(:not_agreed))
    assert_difference("Expense.count", -1) do
      delete expense_url(@expense)
    end
    assert_redirected_to root_url
  end

end