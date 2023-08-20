class DropTableStatusChangedReports < ActiveRecord::Migration[7.0]
  def change
    drop_table :status_changed_reports
  end
end
