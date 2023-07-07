require "test_helper"

class ProcessStatusChangedReportsJobTest < ActiveJob::TestCase
  test "should process status changed report" do
    expense = Expense.create(sum: 1000.00, author: users(:user2), source: bank_accounts(:first), status: expense_statuses(:agreed))
    ExpenseApiUser.create(expense: expense, api_user: api_users(:active))
    StatusChangedReport.create(expense: expense, status: expense.status, responsible: users(:user1))
    assert_difference("StatusChangedReport.count", -1) do
      ProcessStatusChangedReportsJob.perform_now
    end
  end
end
