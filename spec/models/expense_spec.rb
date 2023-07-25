require 'rails_helper'

RSpec.describe Expense, type: :model do
  
  it 'returns agreed and rejected Expenses' do
    expense1 = Expense.create!(source: Cashbox.first, sum: 1000, status: ExpenseStatus.agreed, author: User.first)
    expense2 = Expense.create!(source: Cashbox.first, sum: 1000, status: ExpenseStatus.not_agreed, author: User.first)
    expense3 = Expense.create!(source: Cashbox.first, sum: 1000, status: ExpenseStatus.rejected, author: User.first)
    
    expect(Expense.by_status([ExpenseStatus.agreed, ExpenseStatus.rejected])).to include(expense1, expense3)
    expect(Expense.by_status([ExpenseStatus.agreed])).to_not include(expense2)
  end

  it 'sort by sum' do
    expense1 = Expense.create!(source: Cashbox.first, sum: 2000, status: ExpenseStatus.agreed, author: User.first)
    expense2 = Expense.create!(source: Cashbox.first, sum: 5000, status: ExpenseStatus.not_agreed, author: User.first)
    expense3 = Expense.create!(source: Cashbox.first, sum: 1000, status: ExpenseStatus.rejected, author: User.first)

    expect(Expense.order_by('sum', 'asc').first).to eq(expense3)
    expect(Expense.order_by('sum', 'desc').first).to eq(expense2)
  end

end
