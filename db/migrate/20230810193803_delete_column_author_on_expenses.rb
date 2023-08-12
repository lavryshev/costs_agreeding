class DeleteColumnAuthorOnExpenses < ActiveRecord::Migration[7.0]
  def change
    remove_column :expenses, :author_id
    rename_table :api_users, :external_apps
    add_reference :expenses, :external_app, foreign_key: true
    drop_table :expense_api_users
  end
end
