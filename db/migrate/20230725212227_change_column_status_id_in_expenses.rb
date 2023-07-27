class ChangeColumnStatusIdInExpenses < ActiveRecord::Migration[7.0]
  def change
    change_column :expenses, :status_id, :integer, default: 0
  end
end
