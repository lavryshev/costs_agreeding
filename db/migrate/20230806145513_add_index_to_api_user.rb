class AddIndexToApiUser < ActiveRecord::Migration[7.0]
  def change
    add_index :api_users, :token, unique: true
  end
end
