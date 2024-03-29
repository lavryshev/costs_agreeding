class UsersGroup < ApplicationRecord
  has_many :users_group_members, dependent: :destroy
  has_many :users, through: :users_group_members
  has_many :organization_restrictions, dependent: :destroy
  has_many :organizations, through: :organization_restrictions
  has_many :division_restrictions, dependent: :destroy
  has_many :divisions, through: :division_restrictions

  validates :name, presence: true
end
