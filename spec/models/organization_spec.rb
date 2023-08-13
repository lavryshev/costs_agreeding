require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:externalid) }

  it 'has unique external ID' do
    org1 = create(:organization)
    org2 = create(:organization)

    expect(org1.errors).to be_empty

    org1.externalid = org2.externalid
    org1.save
    expect(org1.errors).not_to be_empty
  end

end