class AddColumnExternalIdForExpenses < ActiveRecord::Migration[7.0]
  def change
    add_column :expenses, :externalid, :string, null: false
    add_index :expenses, :externalid, unique: true
  end
end
