class Expense < ApplicationRecord
  belongs_to :status, class_name: 'ExpenseStatus'
  belongs_to :source, polymorphic: true
  belongs_to :author, class_name: 'User'
  belongs_to :responsible, class_name: 'User', optional: true
  has_one :expense_api_user
  has_one :api_user, through: :expense_api_user

  validates :sum, comparison: { greater_than: 0 }
  validates :payment_date, on: :create, allow_blank: true, comparison: { greater_than_or_equal_to: Date.today }

  paginates_per 10

  scope :by_status, ->(statuses) { where(status: statuses) }
  scope :order_by, ->(order_by = 'created_at', direction = 'asc') { order("#{order_by} #{direction}") }

  def source_sgid
    source&.to_signed_global_id
  end

  def source_sgid=(sgid)
    self.source = GlobalID::Locator.locate_signed(sgid)
  end
end
