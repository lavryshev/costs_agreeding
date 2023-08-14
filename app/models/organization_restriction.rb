class OrganizationRestriction < ApplicationRecord
  belongs_to :users_group
  belongs_to :organization
end
