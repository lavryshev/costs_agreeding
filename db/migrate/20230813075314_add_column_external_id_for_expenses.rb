class AddColumnExternalIdForExpenses < ActiveRecord::Migration[7.0]
  def change
    add_column :expenses, :external_id, :string, null: false
  end
end
