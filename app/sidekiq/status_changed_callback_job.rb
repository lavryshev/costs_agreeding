require 'uri'
require 'net/http'

class StatusChangedCallbackJob
  include Sidekiq::Job

  def perform(expense_id, attempt_number)
    return if attempt_number > 5
    
    expense = Expense.find(expense_id)
    
    if expense && expense.status != 'notagreed'
      uri = URI(expense.external_app.callback_url)
      request_body = { action: 'status_changed', expense: expense.externalid, status: expense.status }.to_json
      
      res = Net::HTTP.post(uri, request_body, 'Content-Type' => 'application/json')
      
      StatusChangedCallbackJob.perform_at(15.minutes.from_now, expense_id, attempt_number+1) unless res.code == '200'
    end
  end
end