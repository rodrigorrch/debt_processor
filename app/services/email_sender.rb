class EmailSender
  def self.send_bill(bill)
    debt = bill.debt

    # Simulate email sending
    Rails.logger.info("Sending email to #{debt.email} for debt: #{debt.debt_id}")

    bill.update!(status: :sent)
  end
end
