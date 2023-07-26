class Expense < ApplicationRecord
  enum status: { notagreed: 0, agreed: 1, rejected: 2 }

  belongs_to :source, polymorphic: true
  belongs_to :author, class_name: 'User'
  belongs_to :responsible, class_name: 'User', optional: true
  has_one :expense_api_user
  has_one :api_user, through: :expense_api_user

  validates :sum, comparison: { greater_than: 0 }
  validates :payment_date, on: :create, allow_blank: true, comparison: { greater_than_or_equal_to: Date.today }

  paginates_per 10

  scope :by_status, ->(statuses) { where(status: statuses) }

  scope :order_by, lambda { |order_by, direction|
    order_by_ = Expense.column_names.include?(order_by) ? order_by : 'created_at'
    direction_ = direction == 'desc' ? 'desc' : 'asc'
    order("#{order_by_} #{direction_}")
  }

  def status_name
    case self.status
    when 'notagreed'
      'Не согласована'
    when 'agreed'
      'Согласована'
    when 'rejected'
      'Отклонена'
    end
  end

  def source_sgid
    source&.to_signed_global_id
  end

  def source_sgid=(sgid)
    self.source = GlobalID::Locator.locate_signed(sgid)
  end
end
