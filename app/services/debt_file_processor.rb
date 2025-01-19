class DebtFileProcessor
  BATCH_SIZE = 1000

  def initialize(file, file_processing)
    @file = file
    @file_processing = file_processing
  end

  def process
    batch = []
    existing_debt_ids = Set.new

    CSV.foreach(@file.path, headers: true) do |row|
      next if row.nil? || row.to_h.values.all?(&:nil?)
      
      debt_id = row["debtId"]
      next if existing_debt_ids.include?(debt_id)
      next if debt_exists?(debt_id)
      
      existing_debt_ids.add(debt_id)
      batch << row.to_h
      
      if batch.size >= BATCH_SIZE
        process_batch(batch)
        batch = []
      end
    end

    process_batch(batch) if batch.any?
  rescue StandardError => e
    @file_processing.update(status: :failed, error_message: e.message)
    Rails.logger.error("Error processing file: #{e.message}")
    raise e
  end

  private

  def debt_exists?(debt_id)
    Debt.exists?(debt_id: debt_id)
  end

  def process_batch(batch)
    # Divide o batch em sub-batches para processamento paralelo
    batch.each_slice(BATCH_SIZE / 4) do |sub_batch|
      BatchDebtProcessingWorker.perform_async(@file_processing.id, sub_batch)
    end
  end
end
