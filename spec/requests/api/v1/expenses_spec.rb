require 'rails_helper'

RSpec.describe 'POST /api/v1/addexpense' do
  let(:extapp) { create(:external_app) }
  let(:expense_params) { attributes_for(:expense) }

  it 'creates service task with action "create_expense"' do
    post_api_v1_addexpense(expense_params, extapp.token)

    expect(response.status).to eq(200)
    expect(ServiceTask.last.action).to eq('create_expense')
  end

  context 'when an invalid token is received' do
    it 'returns a 401' do
      post_api_v1_addexpense(expense_params, 'wrong_token')
      expect(response.status).to eq(401)
    end
  end

  context 'when received token belongs to inactive external app' do
    it 'returns a 401' do
      extapp.active = false
      extapp.save
      post_api_v1_addexpense(expense_params, extapp.token)
      expect(response.status).to eq(401)
    end
  end

  def post_api_v1_addexpense(params, token)
    post api_v1_addexpense_path,
         headers: {
           HTTP_AUTHORIZATION: "Token token=#{token}",
           'Content-Type' => 'application/json'
         },
         params:,
         as: :json
  end
end
