class EmailBatchWorker
  include Sidekiq::Worker
  
  sidekiq_options queue: :mailer,
                  retry: 1,
                  backtrace: true

  def perform(batch_data)
    Bill.includes(:debt).where(debt_id: batch_data).find_each do |bill|
      EmailSender.send_bill(bill)
    end
  end
end
