class User < ApplicationRecord
  has_many :users_group_members, dependent: :destroy
  has_many :users_groups, through: :users_group_members
  has_many :expense_responsible, class_name: 'Expense', foreign_key: 'responsible_id', dependent: :restrict_with_error

  acts_as_authentic do |c|
    c.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
  end

  validates :email,
            format: {
              with: /@/,
              message: 'should look like an email address.'
            },
            length: { maximum: 100 },
            uniqueness: {
              case_sensitive: false,
              if: :will_save_change_to_email?
            },
            presence: true

  validates :login,
            format: {
              with: /\A[a-z0-9]+\z/,
              message: 'should use only letters and numbers.'
            },
            length: { within: 3..100 },
            uniqueness: {
              case_sensitive: false,
              if: :will_save_change_to_login?
            }

  validates :password, confirmation: { if: :require_password? }

  validate :must_exist_admin_on_update, on: :update
  before_destroy :must_exist_admin_on_destroy

  scope :admins, -> { where(is_admin: true) }

  def deliver_password_reset_instructions!
    reset_perishable_token!
    PasswordResetMailer.reset_email(self).deliver_now
  end

  private

  def must_exist_admin_on_update
    return unless is_admin_was && is_admin_changed? && User.admins.count == 1

    errors.add(:base, 'В приложении не останется ни одного администратора!')
  end

  def must_exist_admin_on_destroy
    return unless is_admin && User.admins.count == 1

    errors.add(:base, 'В приложении не останется ни одного администратора!')
    throw :abort
  end
end
