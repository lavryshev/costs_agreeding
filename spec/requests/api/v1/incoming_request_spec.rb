require 'rails_helper'

RSpec.describe 'POST /api/v1/addexpense' do
  let(:api_user) { create(:api_user) }
  let(:expense_params) { attributes_for(:expense) }

  def post_api_v1_addexpense(params, token)
    post api_v1_addexpense_path,
         headers: {
           HTTP_AUTHORIZATION: "Token token=#{token}",
           'Content-Type' => 'application/json'
         },
         params:,
         as: :json
  end

  it 'saves incoming request' do
    post_api_v1_addexpense(expense_params, api_user.token)

    expect(response.status).to eq(200)
    expect(IncomingRequest.last.action).to eq('create_expense')
  end

  it 'adds enqued job to process incoming request' do
    expect do
      post_api_v1_addexpense(expense_params, api_user.token)
    end.to change {
      ActiveJob::Base.queue_adapter.enqueued_jobs.count
    }.by 1
  end

  context 'when an invalid token is received' do
    it 'returns a 401' do
      post_api_v1_addexpense(expense_params, 'wrong_token')
      expect(response.status).to eq(401)
    end
  end

  context 'when received token belongs to inactive api user' do
    it 'returns a 401' do
      api_user.active = false
      api_user.save
      post_api_v1_addexpense(expense_params, api_user.token)
      expect(response.status).to eq(401)
    end
  end
end
