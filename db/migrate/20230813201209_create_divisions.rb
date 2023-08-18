class CreateDivisions < ActiveRecord::Migration[7.0]
  def change
    create_table :divisions do |t|
      t.string :name, null: false
      t.string :externalid, null: false, unique: true
      t.belongs_to :organization, null: false, foreign_key: true
      t.timestamps
    end

    add_reference :expenses, :division, index: true
    add_foreign_key :expenses, :divisions
  end
end
