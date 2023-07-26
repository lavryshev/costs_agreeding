require 'uri'
require 'net/http'

class ProcessStatusChangedReportsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    events = StatusChangedReport.all
    events.each do |e|
      uri = URI("#{e.expense.api_user.webhook_url}/ca/callback")
      res = Net::HTTP.post(uri,
                           { action: 'status_changed', date: e.created_at, expense_id: e.expense.id, status: e.status, responsible_id: e.responsible.id }.to_json, 'Content-Type' => 'application/json')
      e.destroy
    end
  end
end
