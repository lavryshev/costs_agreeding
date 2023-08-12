class ServiceTask < ApplicationRecord
  belongs_to :external_app

  validates :external_app, presence: true
  validates :action, presence: true
  validates :data, presence: true
end
