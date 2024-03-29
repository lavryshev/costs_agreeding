require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'email' do
    it 'should look like an email address' do
      is_expected.not_to allow_value('test.com').for(:email)
    end
    it { is_expected.to validate_length_of(:email).is_at_most(100) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'login' do
    it 'should use only letters and numbers' do
      is_expected.not_to allow_value('abc$(%@123').for(:login)
    end
    it { is_expected.to validate_length_of(:login).is_at_least(3).is_at_most(100) }
    it { is_expected.to validate_uniqueness_of(:login).case_insensitive }
  end

  it { is_expected.to validate_confirmation_of(:password) }

  it 'validates that at least one admin must remain when is_admin flag is changing' do
    admin1 = create(:user, is_admin: true)
    admin2 = create(:user, is_admin: true)

    admin2.is_admin = false
    admin2.save
    expect(admin2.errors).to be_empty

    admin1.is_admin = false
    admin1.save
    expect(admin1.errors).not_to be_empty

    admin1.reload
    expect(admin1.is_admin).to be true
  end

  it 'validates that at leat one admin must remain when user is deleted' do
    admin1 = create(:user, is_admin: true)
    admin2 = create(:user, is_admin: true)

    admin2.destroy
    expect(admin2.destroyed?).to be true

    admin1.destroy
    expect(admin1.errors).not_to be_empty
    expect(admin1.destroyed?).to be false
  end
end

RSpec.describe User, '.admins' do
  it 'returns all admins' do
    admin = create(:user, is_admin: true)
    user1 = create(:user)
    user2 = create(:user)

    admins = User.admins
    expect(admins).to include(admin)
    expect(admins).to_not include([user1, user2])
  end
end

RSpec.describe User, '.restricted_objects' do
  before do
    @o1 = create(:organization)
    @o2 = create(:organization)
    @o3 = create(:organization)
    @d1_o1 = create(:division, organization: @o1)
    @d1_o2 = create(:division, organization: @o2)
    @d2_o2 = create(:division, organization: @o2)

    @user = create(:user)
    @users_group = create(:users_group)
    UsersGroupMember.create(users_group: @users_group, user: @user)
  end

  it 'returns restrictions on organizations and divisions for user' do
    OrganizationRestriction.create(users_group: @users_group, organization: @o2)
    OrganizationRestriction.create(users_group: @users_group, organization: @o3)
    DivisionRestriction.create(users_group: @users_group, division: @d1_o2)
    organizations, divisions = @user.restricted_objects

    expect(organizations).to include(@o3)
    expect(organizations).to_not include(@o1, @o2)

    expect(divisions).to include(@d1_o2)
    expect(divisions).to_not include(@d1_o1, @d2_o2)
  end
end

RSpec.describe User, '#deliver_password_reset_instructions!' do
  it 'sends password reset instructions by email'
end
