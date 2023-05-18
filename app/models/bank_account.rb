class BankAccount < ApplicationRecord
  class << self
    def list_title
      "Банковские счета"
    end
  end
  
  validates :name, presence: true

end
