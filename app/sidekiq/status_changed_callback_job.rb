class StatusChangedCallbackJob
  include Sidekiq::Job

  def perform(expense_id, attempt_number)
    return if attempt_number > 5

    expense = Expense.find(expense_id)

    return unless expense && expense.status != 'notagreed'

    return if ExternalAppAdapter.post_changed_expense_status(expense)

    StatusChangedCallbackJob.perform_at(15.minutes.from_now, expense_id, attempt_number + 1)
  end
end
