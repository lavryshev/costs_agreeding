require 'rails_helper'
RSpec.describe StatusChangedCallbackJob, type: :job do
  subject { described_class.new.perform(expense.id) }
  let(:expense) { create(:expense, status: 'agreed') }

  it 'posts changed status to external app' do
    allow(ExternalAppAdapter).to receive(:post_changed_expense_status).and_return(true)

    described_class.new.perform(expense.id, 1)

    expect(ExternalAppAdapter).to have_received(:post_changed_expense_status).with(expense)
  end

  context 'when post failed' do
    it 'retries this job later' do
      allow(ExternalAppAdapter).to receive(:post_changed_expense_status).and_return(false)

      expect { described_class.new.perform(expense.id, 1) }.to enqueue_sidekiq_job.at(15.minutes.from_now)
    end
  end

end
