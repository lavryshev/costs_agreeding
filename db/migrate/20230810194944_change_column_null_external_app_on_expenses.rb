class ChangeColumnNullExternalAppOnExpenses < ActiveRecord::Migration[7.0]
  def change
    change_column_null :expenses, :external_app_id, false
  end
end
