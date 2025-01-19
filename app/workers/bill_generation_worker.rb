class BillGenerationWorker
  include Sidekiq::Worker

  def perform(debt_id)
    debt = Debt.find(debt_id)
    bill = BillGenerator.generate(debt)
    EmailSender.send_bill(bill)
  end
end
