class AddExpenseApiUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :expense_api_users do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :api_user, null: false, foreign_key: true
    end
  end
end
