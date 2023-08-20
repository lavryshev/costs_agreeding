require 'uri'
require 'net/http'

class ExternalAppAdapter
  def self.post_changed_expense_status(expense)
    new(expense.external_app).post_changed_expense_status(expense)
  end

  def initialize(external_app)
    @external_app = external_app
  end

  def post_changed_expense_status(expense)
    uri = URI(@external_app.callback_url)
    request_body = { action: 'status_changed', expense: expense.externalid, status: expense.status }.to_json
    
    res = Net::HTTP.post(uri, request_body, 'Content-Type' => 'application/json')

    res.code == '200' ? true : false
  end
end