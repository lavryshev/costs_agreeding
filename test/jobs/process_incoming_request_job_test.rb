require "test_helper"

class ProcessIncomingRequestJobTest < ActiveJob::TestCase
  test "should process incoming request" do
    cashbox = cashboxes(:uah)
    author = users(:user1)
    data = {'source_type': 'Cashbox', 'source_id': cashbox.id, 'sum': 100, author_id: author.id}
    r = IncomingRequest.create(api_user: api_users(:active), action: 'create_expense', data: data)

    assert_difference("IncomingRequest.count", -1) do
      assert_difference("ExpenseApiUser.count") do
        ProcessIncomingRequestJob.perform_now
      end
    end
  end
end
