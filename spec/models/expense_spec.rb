require 'rails_helper'

RSpec.describe Expense, type: :model do

  it 'can be filtered by status' do
    expense1 = create(:expense, status: 'agreed')
    expense2 = create(:expense, status: 'notagreed')
    expense3 = create(:expense, status: 'rejected')

    statuses = Expense.statuses
    expect(Expense.by_status([statuses['agreed'], statuses['rejected']])).to include(expense1, expense3)
    expect(Expense.by_status([statuses['agreed']])).to_not include(expense2)
  end

  it 'can sort by sum' do
    expense1 = create(:expense, sum: 2000)
    expense2 = create(:expense, sum: 5000)
    expense3 = create(:expense, sum: 1000)

    expect(Expense.order_by('sum', 'asc')).to eq([expense3, expense1, expense2])
    expect(Expense.order_by('sum', 'desc')).to eq([expense2, expense1, expense3])
  end

end
