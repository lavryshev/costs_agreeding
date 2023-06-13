class Expense < ApplicationRecord
  belongs_to :status, class_name: 'ExpenseStatus'
  belongs_to :source, polymorphic: true
  belongs_to :author, class_name: 'User'
  belongs_to :responsible, class_name: 'User', optional: true

  validates :sum, comparison: { greater_than: 0 }
  validates :payment_date, on: :create, allow_blank: true, comparison: { greater_than_or_equal_to: Date.today }

  paginates_per 10

  def source_sgid
    source&.to_signed_global_id
  end

  def source_sgid=(sgid)
    self.source = GlobalID::Locator.locate_signed(sgid)
  end
end
