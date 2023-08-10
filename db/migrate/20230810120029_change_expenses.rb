class ChangeExpenses < ActiveRecord::Migration[7.0]
  def change
    remove_column :expenses, :source_type
    remove_column :expenses, :source_id
  end
end
