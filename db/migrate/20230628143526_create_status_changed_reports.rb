class CreateStatusChangedReports < ActiveRecord::Migration[7.0]
  def change
    create_table :status_changed_reports do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :responsible, null: false, foreign_key: { to_table: 'users' }
      t.references :status, null: false, foreign_key: { to_table: 'expense_statuses' }
      t.timestamps
    end
  end
end
