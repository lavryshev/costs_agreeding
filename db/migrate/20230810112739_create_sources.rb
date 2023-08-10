class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.string :name, null: false
      t.string :external_id, null: false
      t.index :external_id, unique: true
    end
  end
end
