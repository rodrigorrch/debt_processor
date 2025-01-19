class BatchBillGenerationWorker
  include Sidekiq::Worker
  
  sidekiq_options queue: :bill_generation,
                  retry: 1,
                  backtrace: true

  def perform(batch_data)
    bills_attributes = batch_data.map do |debt_id|
      {
        debt_id: debt_id,
        status: Bill.statuses[:pending],
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    Bill.insert_all!(bills_attributes)
    
    # Processa os emails em lotes menores para não sobrecarregar
    batch_data.each_slice(100) do |batch_ids|
      EmailBatchWorker.perform_async(batch_ids)
    end
  end
end
