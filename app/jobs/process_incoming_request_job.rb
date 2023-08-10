require 'uri'
require 'net/http'

class ProcessIncomingRequestJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    requests = IncomingRequest.where(action: 'create_expense')

    requests.each do |r|
      uri = URI("#{r.api_user.webhook_url}/ca/callback")

      expense = Expense.create(source_id: r.data['source_id'], 
                               sum: r.data['sum'],
                               payment_date: r.data['payment_date'],
                               description: r.data['description'], 
                               author_id: r.data['author_id'])

      if expense.save
        res = Net::HTTP.post(uri, { command_id: r.id, result: 'success', expense_id: expense.id }.to_json,
                             'Content-Type' => 'application/json')
        ExpenseApiUser.create!(expense:, api_user: r.api_user)
      else
        message = expense.errors.full_messages.to_sentence.capitalize
        res = Net::HTTP.post(uri, { command_id: r.id, result: 'error', message: }.to_json,
                             'Content-Type' => 'application/json')
      end

      r.destroy
    end
  end
end
