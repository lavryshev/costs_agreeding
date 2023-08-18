class CreateUsersGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :users_groups do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
