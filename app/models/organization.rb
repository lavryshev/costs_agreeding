class Organization < ApplicationRecord
  include Externable

  validates :name, presence: true

end
