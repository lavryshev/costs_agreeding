class AddExpenseApiUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :expense_api_users do |t|
      t.belongs_to :expense, null: false, foreign_key: true
      t.belongs_to :api_user, null: false, foreign_key: true
    end
  end
end
