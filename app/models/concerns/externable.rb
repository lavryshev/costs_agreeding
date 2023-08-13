module Externable
  extend ActiveSupport::Concern

  included do
    validates :externalid, presence: true, uniqueness: { case_sensitive: true }
  end
end
