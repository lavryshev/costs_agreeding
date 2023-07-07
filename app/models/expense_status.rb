class ExpenseStatus < ApplicationRecord
  class << self
    def not_agreed
      ExpenseStatus.find(1)
    end

    def agreed
      ExpenseStatus.find(2)
    end

    def rejected
      ExpenseStatus.find(3)
    end
  end

  validates :name, presence: true
end
