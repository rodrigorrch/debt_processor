require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe FileProcessingWorker do
  describe '#perform' do
    let(:file_processing) { create(:file_processing, status: :pending) }
    let(:blob) { create(:active_storage_blob) }
    let(:file_content) { File.read(Rails.root.join('spec/fixtures/files/debts.csv')) }
    let(:processor) { instance_double(DebtFileProcessor) }

    before do
      allow(FileProcessing).to receive(:find).with(file_processing.id).and_return(file_processing)
      allow(ActiveStorage::Blob).to receive(:find_signed).with(file_processing.file_blob_id).and_return(blob)
      allow(blob).to receive(:download).and_return(file_content)
      allow(DebtFileProcessor).to receive(:new).and_return(processor)
      allow(processor).to receive(:process)
    end

    it 'processes the file asynchronously' do
      expect {
        described_class.perform_async(file_processing.id)
      }.to change(described_class.jobs, :size).by(1)
    end

    it 'processes the file and updates status' do
      Sidekiq::Testing.inline! do
        described_class.perform_async(file_processing.id)
      end

      expect(file_processing.reload.status).to eq('completed')
      expect(processor).to have_received(:process)
    end

    it 'updates status to processing when starting' do
      expect(file_processing).to receive(:update).with(status: :processing).ordered
      expect(file_processing).to receive(:update).with(status: :completed).ordered

      described_class.new.perform(file_processing.id)
    end

    context 'when processing fails' do
      before do
        allow(processor).to receive(:process).and_raise(StandardError.new('Processing failed'))
      end

      it 'raises the error and does not update status to completed' do
        expect {
          described_class.new.perform(file_processing.id)
        }.to raise_error(StandardError, 'Processing failed')

        expect(file_processing.reload.status).to eq('processing')
      end
    end

    context 'with retry settings' do
      it 'has the correct sidekiq options' do
        expect(described_class.sidekiq_options_hash).to include(
          'retry' => true
        )
      end
    end
  end
end
