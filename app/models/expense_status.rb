class ExpenseStatus < ApplicationRecord
  validates :name, presence: true
end
