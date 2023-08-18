class CreateUsersGroupMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :users_group_members do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :users_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
