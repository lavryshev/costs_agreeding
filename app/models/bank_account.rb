class BankAccount < ApplicationRecord
  class << self
    def list_title
      "Банковские счета"
    end
  end
  
  has_many :expenses, as: :source, dependent: :restrict_with_error

  validates :name, presence: true

end
