class Debt < ApplicationRecord
  validates :name, presence: true
  validates :government_id, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :due_date, presence: true
  validates :debt_id, presence: true, uniqueness: true

  has_one :bill
  belongs_to :file_processing
end
