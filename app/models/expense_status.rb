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

  scope :not_agreed, -> { where(id: 1).first }
  scope :agreed, -> { where(id: 2).first }
  scope :rejected, -> { where(id: 3).first }

  validates :name, presence: true
end
