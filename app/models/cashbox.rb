class Cashbox < ApplicationRecord
  class << self
    def list_title
      "Кассы"
    end
  end
  
  validates :name, presence: true
end
