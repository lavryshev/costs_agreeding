class CreateOrganizationRestrictions < ActiveRecord::Migration[7.0]
  def change
    create_table :organization_restrictions do |t|
      t.belongs_to :users_group, null: false, foreign_key: true
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
