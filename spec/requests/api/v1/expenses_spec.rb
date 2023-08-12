require 'rails_helper'

RSpec.describe Api::V1::ExpensesController do
  let(:extapp) { create(:external_app) }
  let(:test_expense) { create(:expense) }
  let(:expense_params) { attributes_for(:expense) }

  describe 'POST /api/v1/expenses' do
    it 'creates service task with action "create_expense"' do
      post_api_v1_expenses(expense_params, extapp.token)

      last_service_task = ServiceTask.last

      expect(last_service_task.action).to eq('create_expense')

      expect(response.status).to eq(200)
      expect(response_body['command_id']).to eq(last_service_task.id)
    end
  end

  describe 'PATCH /api/v1/expense/:id' do
    it 'creates service task with action "update_expense"' do
      patch_api_v1_expense(expense_params, extapp.token)

      last_service_task = ServiceTask.last

      expect(last_service_task.action).to eq('update_expense')
      expect(last_service_task.data['id'].to_i).to eq(test_expense.id)

      expect(response.status).to eq(200)
      expect(response_body['command_id']).to eq(last_service_task.id)
    end
  end

  describe 'DELETE /api/v1/expense/:id' do
    it 'creates service task with action "destroy_expense"' do
      delete_api_v1_expense(extapp.token)

      last_service_task = ServiceTask.last

      expect(last_service_task.action).to eq('destroy_expense')
      expect(last_service_task.data['id'].to_i).to eq(test_expense.id)

      expect(response.status).to eq(200)
      expect(response_body['command_id']).to eq(last_service_task.id)
    end
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

  def patch_api_v1_expense(params, token)
    patch api_v1_expense_path(test_expense),
          headers: {
            HTTP_AUTHORIZATION: "Token token=#{token}",
            'Content-Type' => 'application/json'
          },
          params:,
          as: :json
  end

  def delete_api_v1_expense(token)
    delete api_v1_expense_path(test_expense),
           headers: {
             HTTP_AUTHORIZATION: "Token token=#{token}",
             'Content-Type' => 'application/json'
           },
           as: :json
  end
end
