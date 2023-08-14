class Division < ApplicationRecord
  include Externable

  belongs_to :organization
  has_many :expenses, dependent: :restrict_with_error
  has_many :division_restrictions, dependent: :destroy
  has_many :users_groups, through: :division_restrictions

  validates :name, presence: true
  validates :organization, presence: true

end
