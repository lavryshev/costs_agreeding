require 'rails_helper'

RSpec.describe Source, type: :model do
  it { is_expected.to validate_presence_of(:name) }

  it 'has unique external ID' do
    source1 = create(:source)
    
    source2 = build(:source, externalid: source1.externalid)
    source2.save
    expect(source2.errors).not_to be_empty
  end
end
