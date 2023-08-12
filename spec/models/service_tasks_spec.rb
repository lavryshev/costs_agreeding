require 'rails_helper'

RSpec.describe ServiceTask, type: :model do
  it { is_expected.to validate_presence_of(:action) }
  it { is_expected.to validate_presence_of(:data) }
  it { is_expected.to validate_presence_of(:external_app) }
end
