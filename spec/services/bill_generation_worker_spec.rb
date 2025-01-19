require 'rails_helper'

RSpec.describe BillGenerationWorker, type: :worker do
  describe '#perform' do
    let(:debt) { create(:debt) }

    it 'generates bill and sends email' do
      worker = described_class.new
      expect(BillGenerator).to receive(:generate).with(debt).and_call_original
      expect(EmailSender).to receive(:send_bill)

      worker.perform(debt.id)
    end
  end
end
