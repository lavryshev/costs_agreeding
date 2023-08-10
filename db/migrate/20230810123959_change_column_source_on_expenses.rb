class ChangeColumnSourceOnExpenses < ActiveRecord::Migration[7.0]
  def change
    change_column_null :expenses, :source_id, false
  end
end
