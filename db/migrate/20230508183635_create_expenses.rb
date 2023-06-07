class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expense_statuses do |t|
      t.string :name, null: false, unique: true
    end
   
    create_table :bank_accounts do |t|
      t.string :name, null: false
    end

    create_table :cashboxes do |t|
      t.string :name, null: false
    end

    create_table :users do |t|
      t.string    :name
      t.string    :email
      t.index     :email, unique: true
      t.string    :login
      t.index     :login, unique: true
      t.string    :crypted_password
      t.string    :password_salt
      t.string    :persistence_token
      t.index     :persistence_token, unique: true
      t.string    :perishable_token
      t.index     :perishable_token, unique: true
      t.boolean   :is_admin, default: false
      t.timestamps
    end

    create_table :expenses do |t|
      t.references :status, foreign_key: { to_table: 'expense_statuses' }
      t.references :source, polymorphic: true
      t.decimal :sum, precision: 15, scale: 2, null: false
      t.datetime :payment_date
      t.references :author, foreign_key: { to_table: 'users' }, null: false
      t.references :responsible, foreign_key: { to_table: 'users' }
      t.text :description
      t.text :notes
      t.timestamps
    end
  end
end
