class StatusChangedReport < ApplicationRecord
  belongs_to :expense
  belongs_to :status, class_name: 'ExpenseStatus'
  belongs_to :responsible, class_name: 'User'
end
