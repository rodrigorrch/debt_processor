require 'rails_helper'

RSpec.describe BillGenerationWorker do
  describe '#perform' do
    let(:debt) { create(:debt) }
    let(:bill) { build(:bill) }

    before do
      allow(Debt).to receive(:find).with(debt.id).and_return(debt)
      allow(BillGenerator).to receive(:generate).with(debt).and_return(bill)
      allow(EmailSender).to receive(:send_bill).with(bill)
    end

    it 'processes the debt and sends the bill' do
      described_class.new.perform(debt.id)

      expect(Debt).to have_received(:find).with(debt.id)
      expect(BillGenerator).to have_received(:generate).with(debt)
      expect(EmailSender).to have_received(:send_bill).with(bill)
    end

    context 'when debt is not found' do
      before do
        allow(Debt).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'raises an error' do
        expect {
          described_class.new.perform(debt.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
