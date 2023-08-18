require 'rails_helper'

RSpec.describe Division, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:organization) }
  it { is_expected.to validate_presence_of(:externalid) }

  it 'has unique external ID' do
    division1 = create(:division)
    division2 = create(:division)

    expect(division1.errors).to be_empty

    division1.externalid = division2.externalid
    division1.save
    expect(division1.errors).not_to be_empty
  end
end
