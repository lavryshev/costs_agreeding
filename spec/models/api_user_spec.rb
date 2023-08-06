require 'rails_helper'

RSpec.describe ApiUser, type: :model do
  
  it { is_expected.to validate_presence_of(:name) }
  
  it 'generates self token on create' do
    au1 = build(:api_user)
    au1.token = nil
    au1.save
    expect(au1.token).not_to be nil
  end

  it 'has unique token' do
    au1 = create(:api_user)
    au2 = create(:api_user)
    
    au1.token = 'dummy'
    au1.save
    expect(au1.errors).to be_empty

    au2.token = 'dummy'
    au2.save
    expect(au2.errors).not_to be_empty
  end

end