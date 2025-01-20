require 'rails_helper'

RSpec.describe DebtFileProcessor do
  let(:file_processing) { create(:file_processing) }
  let(:csv_data) { fixture_file_upload('debts.csv', 'text/csv') }
  let(:processor) { described_class.new(csv_data, file_processing) }

  describe '#process' do
    xit 'processes valid CSV file' do
      expect {
        processor.process
      }.to change(Debt, :count).by(3)
    end

    xit 'handles duplicate debt_ids' do
      create(:debt, debt_id: '1adb6ccf-ff16-467f-bea7-5f05d494280f')

      expect {
        processor.process
      }.to change(Debt, :count).by(2)
    end
  end
end
