class BillGenerator
  def self.generate(debt)
    # Simulate bill generation
    bill = debt.create_bill!(status: :pending)

    # In a real implementation, this would generate a PDF
    Rails.logger.info("Generated bill for debt: #{debt.debt_id}")

    bill.update!(status: :generated)
    bill
  end
end
