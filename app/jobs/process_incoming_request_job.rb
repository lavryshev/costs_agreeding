require 'uri'
require 'net/http'

class ProcessIncomingRequestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    requests = IncomingRequest.where(action: 'create_expense')
    
    requests.each do |r|
      
      uri = URI("#{r.api_user.webhook_url}/ca/callback")
      
      expense = Expense.create(source_type: r.data['source_type'], source_id: r.data['source_id'], sum: r.data['sum'], payment_date: r.data['payment_date'], description: r.data['description'])
      expense.status = ExpenseStatus.not_agreed
      
      if expense.save
        res = Net::HTTP.post(uri, {command_id: r.id, result: 'success'}.to_json, "Content-Type" => "application/json")
      else
        message = expense.errors.full_messages.to_sentence.capitalize
        res = Net::HTTP.post(uri, {command_id: r.id, result: 'error', message: message}.to_json, "Content-Type" => "application/json")
      end

      r.destroy

    end
  end
end
