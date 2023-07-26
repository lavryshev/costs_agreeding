class StatusChangedReport < ApplicationRecord
  belongs_to :expense
  belongs_to :responsible, class_name: 'User'
end
