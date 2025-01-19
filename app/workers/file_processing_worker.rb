class FileProcessingWorker
  include Sidekiq::Worker
  
  sidekiq_options queue: :file_processing,
                  retry: 1,
                  backtrace: true

  def perform(file_processing_id)
    file_processing = FileProcessing.find(file_processing_id)
    file_processing.update(status: :processing)

    return mark_as_failed(file_processing, "Arquivo não encontrado") unless file_processing.file.attached?
    
    file_content = download_file(file_processing)
    return mark_as_failed(file_processing, "Conteúdo do arquivo vazio") if file_content.blank?
    
    DebtFileProcessor.new(file_content, file_processing).process
    file_processing.update(status: :completed)
  rescue StandardError => e
    mark_as_failed(file_processing, e.message)
    Rails.logger.error("Erro processando arquivo: #{e.message}")
    raise e
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

  def mark_as_failed(file_processing, message)
    file_processing.update(status: :failed, error_message: message)
  end
end
