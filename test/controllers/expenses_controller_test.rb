require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expense = Expense.create(sum: 1000.00, author: users(:user1), source: bank_accounts(:first), status: expense_statuses(:not_agreed))
  end

  test "should set agreed status" do
    login(users(:user1))
    put expense_agree_path(@expense)
    assert_response :unprocessable_entity
  end

  test "should set rejected status" do
    login(users(:user1))
    put expense_disagree_path(@expense)
    assert_response :unprocessable_entity
  end
end
