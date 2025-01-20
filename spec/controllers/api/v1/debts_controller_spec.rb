require 'rails_helper'

RSpec.describe Api::V1::DebtsController, type: :controller do
  describe 'POST #upload' do
    let(:file) { fixture_file_upload('debts.csv', 'text/csv') }

    it 'creates a new file processing record' do
      expect {
        post :upload, params: { file: file }
      }.to change(FileProcessing, :count).by(1)
    end

    it 'returns accepted status' do
      post :upload, params: { file: file }
      expect(response).to have_http_status(:accepted)
    end

    it 'enqueues a FileProcessingWorker job' do
      expect {
        post :upload, params: { file: file }
      }.to change(FileProcessingWorker.jobs, :size).by(1)
    end

    context 'with invalid file' do
        let(:file) { fixture_file_upload('invalid.txt', 'text/plain') }

      it 'returns unprocessable_entity status' do
        post :upload, params: { file: file }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #status' do
    let!(:file_processing) { create(:file_processing, :completed) }
    let!(:debts) { create_list(:debt, 3, file_processing: file_processing) }

    it 'returns processing status and statistics' do
      get :status, params: { id: file_processing.id }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('completed')
      expect(json_response['processed_debts']).to eq(3)
    end

    context 'with invalid id' do
      it 'returns not found status' do
        get :status, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
