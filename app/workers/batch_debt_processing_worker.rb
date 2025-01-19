class BatchDebtProcessingWorker
  include Sidekiq::Worker
  
  sidekiq_options queue: :debt_processing,
                  retry: 1,
                  backtrace: true

  def perform(file_processing_id, batch_data)
    debts_attributes = batch_data.map do |row|
      {
        name: row["name"],
        government_id: row["governmentId"],
        email: row["email"],
        amount: row["debtAmount"],
        due_date: row["debtDueDate"],
        debt_id: row["debtId"],
        file_processing_id: file_processing_id,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    Debt.insert_all!(debts_attributes)
    
    # Enfileira geração de boletos em batch
    debt_ids = Debt.where(file_processing_id: file_processing_id)
                   .where(debt_id: batch_data.pluck("debtId"))
                   .pluck(:id)
    
    BatchBillGenerationWorker.perform_async(debt_ids)
  rescue StandardError => e
    Rails.logger.error("Error processing batch: #{e.message}")
    raise e
  end
end
