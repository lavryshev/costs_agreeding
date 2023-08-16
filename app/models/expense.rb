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

  after_save :add_status_change_report, if: proc { saved_change_to_status? }

  paginates_per 10

  scope :all_permitted, lambda { |user|
    restricted_divisions = user.divisions
    related_organizations_ids = restricted_divisions.collect { |d| d.organization.id }
    restricted_organizations = user.organizations.where.not(id: related_organizations_ids)
    result = where(nil)
    unless restricted_divisions.empty?
      result = result.where(division: restricted_divisions)
    end
    unless restricted_organizations.empty?
      result = restricted_divisions.empty? ? result.where(organization: restricted_organizations) : result.or(where(organization: restricted_organizations))
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
    restricted_divisions = user.divisions
    related_organizations_ids = restricted_divisions.collect { |d| d.organization.id }
    restricted_organizations = user.organizations.where.not(id: related_organizations_ids)
    if restricted_divisions.empty? && restricted_organizations.empty?
      return true
    else
      return restricted_organizations.include?(self.organization) || restricted_divisions.include?(self.division)
    end
  end

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
