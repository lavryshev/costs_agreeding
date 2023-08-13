class Expense < ApplicationRecord
  include Filterable, Externable

  enum status: { notagreed: 0, agreed: 1, rejected: 2 }

  belongs_to :source
  belongs_to :responsible, class_name: 'User', optional: true
  belongs_to :external_app
  has_many :status_changed_reports

  validates :external_app, presence: true
  validates :source, presence: true
  validates :sum, comparison: { greater_than: 0 }
  validates :payment_date, on: :create, allow_blank: true, comparison: { greater_than_or_equal_to: Date.today }

  after_save :add_status_change_report, if: proc { saved_change_to_status? }

  paginates_per 10

  scope :filter_by_statuses, lambda { |statuses|
    status_ids = statuses.select { |value| value != '' && value.to_i >= 0 }
    if status_ids.empty?
      where(nil)
    else
      where(status: status_ids)
    end
  }

  scope :order_by, lambda { |order_by, direction|
    order_by_ = Expense.column_names.include?(order_by) ? order_by : 'created_at'
    direction_ = direction == 'desc' ? 'desc' : 'asc'
    order("#{order_by_} #{direction_}")
  }

  private

  def add_status_change_report
    StatusChangedReport.create(expense: self, responsible:, status:)
    ProcessStatusChangedReportsJob.perform_later
  end
end
