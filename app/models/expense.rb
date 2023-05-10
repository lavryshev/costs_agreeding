class Expense < ApplicationRecord
  belongs_to :expense_status
  belongs_to :source, polymorphic: true
  belongs_to :author, class_name: "User"
  belongs_to :responsible, class_name: "User"
end
