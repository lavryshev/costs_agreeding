class Expense < ApplicationRecord
  include Externable
  include Filterable

  enum status: { notagreed: 0, agreed: 1, rejected: 2 }

  belongs_to :source
  belongs_to :responsible, class_name: 'User', optional: true
  belongs_to :external_app
  belongs_to :organization
  belongs_to :division, optional: true
  has_many :status_changed_reports

  validates :organization, presence: true
  validates :external_app, presence: true
  validates :source, presence: true
  validates :sum, comparison: { greater_than: 0 }
  validates :payment_date, on: :create, allow_blank: true, comparison: { greater_than_or_equal_to: Date.today }

  after_commit :status_changed_callback, on: :update

  paginates_per 10

  scope :all_permitted, lambda { |user|
    organizations, divisions = user.restricted_objects
    result = where(nil)
    result = result.where(division: divisions) unless divisions.empty?
    unless organizations.empty?
      result = divisions.empty? ? result.where(organization: organizations) : result.or(where(organization: organizations))
    end
    return result
  }

  scope :filter_by_statuses, lambda { |statuses|
    status_ids = statuses.select { |value| value != '' && value.to_i >= 0 }
    if status_ids.empty?
      where(nil)
    else
      where(status: status_ids)
    end
  }

  def permitted?(user)
    organizations, divisions = user.restricted_objects
    return true if divisions.empty? && organizations.empty?

    organizations.include?(organization) || divisions.include?(division)
  end

  scope :order_by, lambda { |order_by, direction|
    order_by_ = Expense.column_names.include?(order_by) ? order_by : 'created_at'
    direction_ = direction == 'desc' ? 'desc' : 'asc'
    order("#{order_by_} #{direction_}")
  }

  private

  def status_changed_callback
    StatusChangedCallbackJob.perform_async(id, 1)
  end
end
