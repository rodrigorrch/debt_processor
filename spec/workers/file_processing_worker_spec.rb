RSpec.describe FileProcessingWorker do
  describe '#perform' do
    let(:file_processing) { create(:file_processing, status: :pending) }
    let(:file) { fixture_file_upload('spec/fixtures/files/debts.csv', 'text/csv') }

    before do
      file_processing.file.attach(file)
      allow(DebtFileProcessor).to receive(:new).and_return(double(process: true))
    end

    it 'processes the file and updates status' do
      described_class.new.perform(file_processing.id)
      expect(file_processing.reload.status).to eq('completed')
    end

    context 'when processing fails' do
      before do
        allow(DebtFileProcessor).to receive(:new)
          .and_raise(StandardError.new('Processing failed'))
      end

      it 'raises the error and does not update status to completed' do
        expect {
          described_class.new.perform(file_processing.id)
        }.to raise_error(StandardError, 'Processing failed')
        
        expect(file_processing.reload.status).to eq('failed')
      end
    end
  end
end
