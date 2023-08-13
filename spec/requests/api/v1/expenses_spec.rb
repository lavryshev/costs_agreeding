require 'rails_helper'

RSpec.describe Api::V1::ExpensesController do
  let(:extapp) { create(:external_app) }

  describe 'POST /api/v1/expenses' do
    it 'creates expense' do
      test_source = create(:source)
      expense_params = { externalid: 'abc123', sum: BigDecimal('1090.00'), source_externalid: test_source.externalid }
      post_api_v1_expenses(expense_params, extapp.token)

      expect(response.status).to eq(201)      
      expect(Expense.last.externalid).to eq(expense_params[:externalid])
    end

    context 'when there are invalid attributes' do
      it 'returns a 422 with errors' do
        expense_params = attributes_for(:expense)
        post_api_v1_expenses(expense_params, extapp.token)
        
        expect(response.status).to eq(422)
        expect(response_body.fetch('errors')).not_to be_empty
      end
    end
  end

  describe 'PATCH /api/v1/expense/:id' do
    let(:test_expense) { create(:expense) }

    it 'updates expense' do
      expense_params = { id: test_expense.id, externalid: test_expense.externalid, sum: BigDecimal('990.00'), source_externalid: test_expense.source.externalid }
      patch_api_v1_expense(expense_params, extapp.token)

      test_expense.reload
      expect(response.status).to eq(200)
      expect(test_expense.sum).to eq(expense_params[:sum])
    end

    context 'when there are invalid attributes' do
      it 'returns a 422 with errors' do
        expense_params = { id: test_expense.id, externalid: test_expense.externalid, sum: BigDecimal('0.00'), source_externalid: test_expense.source.externalid }
        patch_api_v1_expense(expense_params, extapp.token)
          
        expect(response.status).to eq(422)
        expect(response_body.fetch('errors')).not_to be_empty
      end
    end
  end

  describe 'DELETE /api/v1/expense/:id' do
    let(:test_expense) { create(:expense) }

    it 'destroys expense' do
      expense_params = { id: test_expense.id, externalid: test_expense.externalid }
      delete_api_v1_expense(expense_params, extapp.token)

      expect(response.status).to eq(200)
      expect(Expense.find_by(id: test_expense.id)).to eq(nil)
    end
  end

  context 'when an invalid token is received' do
    it 'returns a 401' do
      expense_params = attributes_for(:expense)
      post_api_v1_expenses(expense_params, 'wrong_token')
      expect(response.status).to eq(401)
    end
  end

  context 'when received token belongs to inactive external app' do
    it 'returns a 401' do
      expense_params = attributes_for(:expense)
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
    patch api_v1_expense_path,
          headers: {
            HTTP_AUTHORIZATION: "Token token=#{token}",
            'Content-Type' => 'application/json'
          },
          params:,
          as: :json
  end

  def delete_api_v1_expense(params, token)
    delete api_v1_expense_path,
           headers: {
             HTTP_AUTHORIZATION: "Token token=#{token}",
             'Content-Type' => 'application/json'
           },
           params:,
           as: :json
  end
end
