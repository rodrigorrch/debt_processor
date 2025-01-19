require 'rails_helper'

RSpec.describe FileProcessing, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:filename) }
    it { should validate_presence_of(:status) }
  end

  describe 'associations' do
    it { should have_many(:debts) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, processing: 1, completed: 2, failed: 3) }
  end

  describe 'state transitions' do
    let(:file_processing) { create(:file_processing) }

    it 'starts with pending status' do
      expect(file_processing.status).to eq('pending')
    end

    it 'can transition from pending to processing' do
      file_processing.processing!
      expect(file_processing.status).to eq('processing')
    end

    it 'can transition from processing to completed' do
      file_processing.processing!
      file_processing.completed!
      expect(file_processing.status).to eq('completed')
    end

    it 'can transition from processing to failed' do
      file_processing.processing!
      file_processing.failed!
      expect(file_processing.status).to eq('failed')
    end
  end
end
