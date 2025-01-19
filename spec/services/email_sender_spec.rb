require 'rails_helper'

RSpec.describe EmailSender do
  describe '.send_bill' do
    let(:debt) { create(:debt) }
    let(:bill) { create(:bill, debt: debt, status: :generated) }

    before do
      allow(Rails.logger).to receive(:info)
    end

    it 'logs the email sending information' do
      EmailSender.send_bill(bill)

      expect(Rails.logger).to have_received(:info)
        .with("Sending email to #{debt.email} for debt: #{debt.debt_id}")
    end

    it 'updates bill status to sent' do
      expect {
        EmailSender.send_bill(bill)
      }.to change { bill.reload.status }.from('generated').to('sent')
    end

    context 'when bill update fails' do
      before do
        allow(bill).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises an error' do
        expect {
          EmailSender.send_bill(bill)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with invalid bill status' do
      let(:sent_bill) { create(:bill, debt: debt, status: :sent) }

      it 'still processes the email' do
        EmailSender.send_bill(sent_bill)
        expect(Rails.logger).to have_received(:info)
      end
    end
  end
end
