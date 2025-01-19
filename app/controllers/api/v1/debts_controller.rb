module Api
  module V1
    class DebtsController < ApplicationController
      def upload
        return render json: { error: "Invalid file type" }, status: :unprocessable_entity unless valid_file?

        file_processing = FileProcessing.create!(
          filename: params[:file].original_filename,
          status: :pending
        )

        file_processing.file.attach(params[:file])
        FileProcessingWorker.perform_async(file_processing.id)

        render json: { 
          message: "File received and being processed",
          file_processing_id: file_processing.id 
        }, status: :accepted
      end

      def status
        file_processing = FileProcessing.find(params[:id])
        render json: {
          status: file_processing.status,
          processed_debts: file_processing.debts.count,
          total_amount: file_processing.debts.sum(:amount),
          error_message: file_processing.error_message
        }
      rescue ActiveRecord::RecordNotFound
        render json: { error: "File processing not found" }, status: :not_found
      end

      private

      def valid_file?
        return false unless params[:file].present?
        return false unless params[:file].content_type == "text/csv"
        true
      end
    end
  end
end
