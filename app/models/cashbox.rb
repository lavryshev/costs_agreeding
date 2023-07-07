class Cashbox < ApplicationRecord
  class << self
    def list_title
      'Кассы'
    end
  end

  has_many :expenses, as: :source, dependent: :restrict_with_error

  validates :name, presence: true
end
