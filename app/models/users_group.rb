class UsersGroup < ApplicationRecord
  validates :name, presence: true
end
