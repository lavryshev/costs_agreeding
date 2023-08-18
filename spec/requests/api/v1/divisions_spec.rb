require 'rails_helper'

RSpec.describe Api::V1::DivisionsController do
  let(:extapp) { create(:external_app) }

  describe 'POST /api/v1/divisions' do
    it 'creates division' do
      test_organization = create(:organization)
      division_params = { externalid: 'abc123', name: 'Склад №10',
                          organization_externalid: test_organization.externalid }
      post_api_v1_divisions(division_params, extapp.token)

      expect(response.status).to eq(201)
      expect(Division.last.externalid).to eq(division_params[:externalid])
    end

    context 'when there are invalid attributes' do
      it 'returns a 422 with errors' do
        division_params = attributes_for(:division)
        division_params[:name] = ''
        post_api_v1_divisions(division_params, extapp.token)

        expect(response.status).to eq(422)
        expect(response_body.fetch('errors')).not_to be_empty
      end
    end
  end

  describe 'PATCH /api/v1/division' do
    let(:test_division) { create(:division) }

    it 'updates division' do
      division_params = { name: 'New Name', externalid: test_division.externalid,
                          organization_externalid: test_division.organization.externalid }
      patch_api_v1_division(division_params, extapp.token)

      test_division.reload
      expect(response.status).to eq(200)
      expect(test_division.name).to eq(division_params[:name])
    end

    context 'when there are invalid attributes' do
      it 'returns a 422 with errors' do
        division_params = { name: '', externalid: test_division.externalid,
                            organization_externalid: test_division.organization.externalid }
        patch_api_v1_division(division_params, extapp.token)

        expect(response.status).to eq(422)
        expect(response_body.fetch('errors')).not_to be_empty
      end
    end
  end

  describe 'DELETE /api/v1/division' do
    let(:test_division) { create(:division) }

    it 'destroys division' do
      division_params = { externalid: test_division.externalid }
      delete_api_v1_division(division_params, extapp.token)

      expect(response.status).to eq(200)
      expect(Division.find_by(id: test_division.id)).to eq(nil)
    end
  end

  context 'when an invalid token is received' do
    it 'returns a 401' do
      division_params = attributes_for(:division)
      post_api_v1_divisions(division_params, 'wrong_token')
      expect(response.status).to eq(401)
    end
  end

  context 'when received token belongs to inactive external app' do
    it 'returns a 401' do
      division_params = attributes_for(:division)
      extapp.active = false
      extapp.save
      post_api_v1_divisions(division_params, extapp.token)
      expect(response.status).to eq(401)
    end
  end

  def post_api_v1_divisions(params, token)
    post api_v1_divisions_path,
         headers: {
           HTTP_AUTHORIZATION: "Token token=#{token}",
           'Content-Type' => 'application/json'
         },
         params:,
         as: :json
  end

  def patch_api_v1_division(params, token)
    patch api_v1_division_path,
          headers: {
            HTTP_AUTHORIZATION: "Token token=#{token}",
            'Content-Type' => 'application/json'
          },
          params:,
          as: :json
  end

  def delete_api_v1_division(params, token)
    delete api_v1_division_path,
           headers: {
             HTTP_AUTHORIZATION: "Token token=#{token}",
             'Content-Type' => 'application/json'
           },
           params:,
           as: :json
  end
end
