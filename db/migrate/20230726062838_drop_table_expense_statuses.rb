class DropTableExpenseStatuses < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :status_changed_reports, column: :status_id
    rename_column :status_changed_reports, :status_id, :status
    drop_table :expense_statuses
  end
end
