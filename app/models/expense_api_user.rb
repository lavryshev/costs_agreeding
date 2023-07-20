class ExpenseApiUser < ApplicationRecord
  belongs_to :expense
  belongs_to :api_user
end
