class ExternalApp < ApplicationRecord
  has_many :expenses

  validates :name, presence: true
  validates :token, uniqueness: { case_sensitive: true }

  before_validation :generate_token, on: :create

  encrypts :token, deterministic: true

  private

  def generate_token
    self.token = Digest::MD5.hexdigest(SecureRandom.hex)
  end
end
