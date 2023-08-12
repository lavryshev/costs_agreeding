require 'rails_helper'

RSpec.describe 'POST /api/v1/expenses' do
  let(:extapp) { create(:external_app) }
  let(:expense_params) { attributes_for(:expense) }

  it 'creates service task with action "create_expense"' do
    post_api_v1_expenses(expense_params, extapp.token)

    last_service_task = ServiceTask.last

    expect(last_service_task.action).to eq('create_expense')

    expect(response.status).to eq(200)
    expect(response_body['command_id']).to eq(last_service_task.id)
  end

  context 'when an invalid token is received' do
    it 'returns a 401' do
      post_api_v1_expenses(expense_params, 'wrong_token')
      expect(response.status).to eq(401)
    end
  end

  context 'when received token belongs to inactive external app' do
    it 'returns a 401' do
      extapp.active = false
      extapp.save
      post_api_v1_expenses(expense_params, extapp.token)
      expect(response.status).to eq(401)
    end
  end

  def post_api_v1_expenses(params, token)
    post api_v1_expenses_path,
         headers: {
           HTTP_AUTHORIZATION: "Token token=#{token}",
           'Content-Type' => 'application/json'
         },
         params:,
         as: :json
  end
end
