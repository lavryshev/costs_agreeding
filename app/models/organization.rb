class Organization < ApplicationRecord
  include Externable

  has_many :divisions, dependent: :restrict_with_error
  has_many :expenses, dependent: :restrict_with_error

  validates :name, presence: true

end