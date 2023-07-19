class ExpenseStatus < ApplicationRecord
  # class << self
  #   def not_agreed
  #     ExpenseStatus.find(1)
  #   end

  #   def agreed
  #     ExpenseStatus.find(2)
  #   end

  #   def rejected
  #     ExpenseStatus.find(3)
  #   end
  # end

  scope :not_agreed, -> { find(1) }
  scope :agreed, -> { find(2) }
  scope :rejected, -> { find(3) }

  validates :name, presence: true
end
