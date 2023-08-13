class Organization < ApplicationRecord
  include Externable

  has_many :expenses, dependent: :restrict_with_error

  validates :name, presence: true

end
