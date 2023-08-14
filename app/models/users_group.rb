class UsersGroup < ApplicationRecord
  has_many :users_group_members, dependent: :destroy
  has_many :users, through: :users_group_members

  validates :name, presence: true
end
