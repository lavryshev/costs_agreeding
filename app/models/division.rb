class Division < ApplicationRecord
  include Externable

  belongs_to :organization
  has_many :expenses, dependent: :restrict_with_error

  validates :name, presence: true
  validates :organization, presence: true

end
