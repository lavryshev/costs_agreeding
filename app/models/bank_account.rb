class BankAccount < ApplicationRecord
  validates :name, presence: true
end
