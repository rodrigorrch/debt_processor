require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'associations' do
    it { should belong_to(:debt) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, generated: 1, sent: 2, error: 3) }
  end

  describe 'state transitions' do
    let(:bill) { create(:bill) }

    it 'starts with pending status' do
      expect(bill.status).to eq('pending')
    end

    it 'can transition from pending to generated' do
      bill.generated!
      expect(bill.status).to eq('generated')
    end

    it 'can transition from generated to sent' do
      bill.generated!
      bill.sent!
      expect(bill.status).to eq('sent')
    end

    it 'can transition to error from any state' do
      bill.error!
      expect(bill.status).to eq('error')
    end
  end
end
