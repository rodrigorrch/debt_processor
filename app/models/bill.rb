class Bill < ApplicationRecord
  belongs_to :debt

  validates :status, presence: true
  enum :status, { pending: 0, generated: 1, sent: 2, error: 3 }
end
