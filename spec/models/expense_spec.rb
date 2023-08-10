require 'rails_helper'

RSpec.describe Expense, type: :model do
  it { is_expected.to validate_presence_of(:source) }
  it { is_expected.to validate_presence_of(:external_app) }
  
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

RSpec.describe Expense, '.filter_by_statuses' do
  it 'filters expenses by status' do
    expense1 = create(:expense, status: 'agreed')
    expense2 = create(:expense, status: 'notagreed')
    expense3 = create(:expense, status: 'rejected')
    statuses = Expense.statuses
    expect(Expense.filter_by_statuses([statuses['agreed'], statuses['rejected']])).to include(expense1, expense3)
    expect(Expense.filter_by_statuses([statuses['agreed']])).to_not include(expense2)
  end
end

RSpec.describe Expense, '.order_by' do
  it 'sorts expenses' do
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

RSpec.describe Expense, 'after save' do
  let(:extapp) { create(:external_app, active: true) }
  let(:user) { create(:user) }
  let(:expense) { create(:expense, external_app: extapp) }

  context 'when status changed' do
    it 'adds record to status changed report' do
      expect(expense.status_changed_reports).to be_empty
      expense.update(status: 'agreed', responsible: user)
      expect(expense.status_changed_reports).not_to be_empty
    end

    it 'adds enqued job to process changed status' do
      expect do
        expense.update(status: 'agreed', responsible: user)
      end.to change {
        ActiveJob::Base.queue_adapter.enqueued_jobs.count
      }.by 1
    end
  end
end
