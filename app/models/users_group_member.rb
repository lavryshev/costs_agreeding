class UsersGroupMember < ApplicationRecord
  belongs_to :user
  belongs_to :users_group
end
