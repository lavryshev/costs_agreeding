class RenameColumnStatusIdInExpenses < ActiveRecord::Migration[7.0]
  def change
    rename_column(:expenses, :status_id, :status)
  end
end
