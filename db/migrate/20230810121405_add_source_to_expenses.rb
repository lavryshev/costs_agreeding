class AddSourceToExpenses < ActiveRecord::Migration[7.0]
  def change
    add_reference :expenses, :source, foreign_key: true
    drop_table :cashboxes
    drop_table :bank_accounts
  end
end
