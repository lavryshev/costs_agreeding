require 'rails_helper'

RSpec.describe Expense, type: :model do

  it 'has three statuses' do
    expense = build(:expense)
    
    expense.status = 'notagreed'
    expect(expense.status).to eq('notagreed')
    
    expense.status = 'agreed'
    expect(expense.status).to eq('agreed')
    
    expense.status = 'rejected'
    expect(expense.status).to eq('rejected')
  end

  it "has default status 'notagreed'" do
    expense = build(:expense)
    expect(expense.status).to eq('notagreed')
  end

  it 'sum must be greater than 0' do
    expense = build(:expense)
    expense.sum = 0
    expect(expense).not_to be_valid
  end

  it 'payment date can not be less than today date on create' do
    expense = build(:expense)
    expense.payment_date = Date.yesterday
    expect(expense).not_to be_valid
  end

end

RSpec.describe Expense, '.by_status' do
  it 'can be filtered by status' do
    expense1 = create(:expense, status: 'agreed')
    expense2 = create(:expense, status: 'notagreed')
    expense3 = create(:expense, status: 'rejected')
    statuses = Expense.statuses
    expect(Expense.by_status([statuses['agreed'], statuses['rejected']])).to include(expense1, expense3)
    expect(Expense.by_status([statuses['agreed']])).to_not include(expense2)
  end
end

RSpec.describe Expense, '.order_by' do
  it 'can be sorted' do
    expense1 = create(:expense, sum: 2000)
    expense2 = create(:expense, sum: 5000)
    expense3 = create(:expense, sum: 1000)
    expect(Expense.order_by('sum', 'asc')).to eq([expense3, expense1, expense2])
    expect(Expense.order_by('sum', 'desc')).to eq([expense2, expense1, expense3])
  end
end

RSpec.describe Expense, '.page' do
  it 'paginates' do
    3.times do
      create(:expense)
    end
    Expense.paginates_per 2
    expect(Expense.page(1).size).to eq(2)
    expect(Expense.page(2).size).to eq(1)
    expect(Expense.page(3).size).to eq(0)
  end
end

RSpec.describe Expense, '#source_sgid' do
  it 'returns source signed global id' do
    cashbox = create(:cashbox)
    expense = build(:expense, source: cashbox)
    expect(expense.source_sgid).to eq(cashbox&.to_signed_global_id)
  end
end

RSpec.describe Expense, '#source_sgid=' do
  it 'set source by it signed global id' do
    cashbox = create(:cashbox)
    expense = build(:expense)
    expense.source_sgid = cashbox&.to_signed_global_id
    expect(expense.source).to eq(cashbox)
  end
end

RSpec.describe Expense, '#status_name' do
  it 'returns name of current status' do
    expense = build(:expense)
    expect(expense.status_name.class).to eq(String)
  end
end