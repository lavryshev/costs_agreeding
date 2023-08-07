require 'rails_helper'

RSpec.describe Cashbox, type: :model do
  it { is_expected.to validate_presence_of(:name) }
end

RSpec.describe Cashbox, '.list_title' do
  it 'returns source type name' do
    expect(Cashbox.list_title.class).to eq(String)
  end
end
