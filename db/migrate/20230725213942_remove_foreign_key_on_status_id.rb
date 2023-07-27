class RemoveForeignKeyOnStatusId < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :expenses, column: :status
  end
end
