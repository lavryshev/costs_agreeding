class AddOrganizationsToExpenses < ActiveRecord::Migration[7.0]
  def change
    add_reference :expenses, :organization, null: false, index: true
    add_foreign_key :expenses, :organizations
  end
end
