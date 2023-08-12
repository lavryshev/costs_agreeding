require 'uri'
require 'net/http'

class ProcessIncomingRequestJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    ServiceTask.all.each do |r|
      create_expense(r.external_app, r.data) if r.action == 'create_expense'

      r.destroy
    end
  end

  def create_expense(_external_app, _data)
    uri = URI("#{r.external_app.webhook_url}/ca/callback")

    expense = Expense.create(source_id: r.data['source_id'],
                             sum: r.data['sum'],
                             payment_date: r.data['payment_date'],
                             description: r.data['description'],
                             external_app: r.external_app)

    if expense.save
      res = Net::HTTP.post(uri, { command_id: r.id, result: 'success', expense_id: expense.id }.to_json,
                           'Content-Type' => 'application/json')
    else
      message = expense.errors.full_messages.to_sentence.capitalize
      res = Net::HTTP.post(uri, { command_id: r.id, result: 'error', message: }.to_json,
                           'Content-Type' => 'application/json')
    end
  end
end
