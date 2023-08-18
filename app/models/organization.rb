class Organization < ApplicationRecord
  include Externable

  has_many :divisions, dependent: :restrict_with_error
  has_many :expenses, dependent: :restrict_with_error
  has_many :organization_restrictions, dependent: :destroy
  has_many :users_groups, through: :organization_restrictions

  validates :name, presence: true
end
