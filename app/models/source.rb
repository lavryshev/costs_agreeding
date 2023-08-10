class Source < ApplicationRecord
  has_many :expenses, dependent: :restrict_with_error

  validates :name, presence: true
  validates :externalid, uniqueness: { case_sensitive: true }
end
