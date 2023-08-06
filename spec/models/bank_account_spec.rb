require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  it { is_expected.to validate_presence_of(:name) }
end

RSpec.describe BankAccount, '.list_title' do
  it 'returns source type name' do
    expect(BankAccount.list_title.class).to eq(String)
  end
end
