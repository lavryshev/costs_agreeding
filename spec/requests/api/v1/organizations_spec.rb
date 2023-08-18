require 'rails_helper'

RSpec.describe Api::V1::OrganizationsController do
  let(:extapp) { create(:external_app) }

  describe 'POST /api/v1/organizations' do
    it 'creates organization' do
      organization_params = attributes_for(:organization)
      post_api_v1_organizations(organization_params, extapp.token)

      expect(response.status).to eq(201)
      expect(Organization.last.externalid).to eq(organization_params[:externalid])
    end

    context 'when there are invalid attributes' do
      it 'returns a 422 with errors' do
        organization_params = attributes_for(:organization)
        organization_params[:name] = ''
        post_api_v1_organizations(organization_params, extapp.token)

        expect(response.status).to eq(422)
        expect(response_body.fetch('errors')).not_to be_empty
      end
    end
  end

  describe 'PATCH /api/v1/organization' do
    let(:test_organization) { create(:organization) }

    it 'updates organization' do
      organization_params = { name: 'New Name', externalid: test_organization.externalid }
      patch_api_v1_organization(organization_params, extapp.token)

      test_organization.reload
      expect(response.status).to eq(200)
      expect(test_organization.name).to eq(organization_params[:name])
    end

    context 'when there are invalid attributes' do
      it 'returns a 422 with errors' do
        organization_params = { name: '', externalid: test_organization.externalid }
        patch_api_v1_organization(organization_params, extapp.token)

        expect(response.status).to eq(422)
        expect(response_body.fetch('errors')).not_to be_empty
      end
    end
  end

  describe 'DELETE /api/v1/organization' do
    let(:test_organization) { create(:organization) }

    it 'destroys organization' do
      organization_params = { externalid: test_organization.externalid }
      delete_api_v1_organization(organization_params, extapp.token)

      expect(response.status).to eq(200)
      expect(Organization.find_by(id: test_organization.id)).to eq(nil)
    end
  end

  context 'when an invalid token is received' do
    it 'returns a 401' do
      organization_params = attributes_for(:organization)
      post_api_v1_organizations(organization_params, 'wrong_token')
      expect(response.status).to eq(401)
    end
  end

  context 'when received token belongs to inactive external app' do
    it 'returns a 401' do
      organization_params = attributes_for(:organization)
      extapp.active = false
      extapp.save
      post_api_v1_organizations(organization_params, extapp.token)
      expect(response.status).to eq(401)
    end
  end

  def post_api_v1_organizations(params, token)
    post api_v1_organizations_path,
         headers: {
           HTTP_AUTHORIZATION: "Token token=#{token}",
           'Content-Type' => 'application/json'
         },
         params:,
         as: :json
  end

  def patch_api_v1_organization(params, token)
    patch api_v1_organization_path,
          headers: {
            HTTP_AUTHORIZATION: "Token token=#{token}",
            'Content-Type' => 'application/json'
          },
          params:,
          as: :json
  end

  def delete_api_v1_organization(params, token)
    delete api_v1_organization_path,
           headers: {
             HTTP_AUTHORIZATION: "Token token=#{token}",
             'Content-Type' => 'application/json'
           },
           params:,
           as: :json
  end
end
