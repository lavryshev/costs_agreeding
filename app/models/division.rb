class Division < ApplicationRecord
  include Externable

  belongs_to :organization
  
  has_many :expenses, dependent: :restrict_with_error
  
  has_many :division_restrictions, dependent: :destroy
  has_many :users_groups, through: :division_restrictions
  has_many :users_group_members, through: :users_groups
  has_many :users, through: :users_group_members

  validates :name, presence: true
  validates :organization, presence: true

end
