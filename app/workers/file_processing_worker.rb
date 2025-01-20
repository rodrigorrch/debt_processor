class FileProcessingWorker
  include Sidekiq::Worker

  sidekiq_options queue: :file_processing,
                  retry: 1,
                  backtrace: true

  def perform(file_processing_id)
    file_processing = FileProcessing.find(file_processing_id)
    file_processing.update!(status: :processing)

    begin
      if !file_processing.file.attached?
        file_processing.update!(status: :failed, error_message: "Arquivo não encontrado")
        return
      end

      file_content = download_file(file_processing)
      if file_content.blank?
        file_processing.update!(status: :failed, error_message: "Conteúdo do arquivo vazio")
        return
      end

      DebtFileProcessor.new(file_content, file_processing).process
      file_processing.update!(status: :completed)
    rescue StandardError => e
      file_processing.update!(status: :failed, error_message: e.message)
      raise e
    end
  end

  private

  def download_file(file_processing)
    tempfile = Tempfile.new
    file_processing.file.download do |chunk|
      tempfile.write(chunk)
    end
    tempfile.rewind
    tempfile
  end
end