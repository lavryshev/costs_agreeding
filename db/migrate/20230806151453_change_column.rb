class ChangeColumn < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :login, false
    change_column_null :users, :email, false
  end
end
