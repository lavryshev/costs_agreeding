require 'rails_helper'

RSpec.describe ExternalApp, type: :model do
  it { is_expected.to validate_presence_of(:name) }

  it 'generates self token on create' do
    extapp = build(:external_app)
    extapp.token = nil
    extapp.save
    expect(extapp.token).not_to be nil
  end

  it 'has unique token' do
    extapp1 = create(:external_app)
    extapp2 = create(:external_app)

    extapp1.token = 'dummy'
    extapp1.save
    expect(extapp1.errors).to be_empty

    extapp2.token = 'dummy'
    extapp2.save
    expect(extapp2.errors).not_to be_empty
  end
end
