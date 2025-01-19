class FileProcessing < ApplicationRecord
  has_one_attached :file
  belongs_to :file_blob, class_name: 'ActiveStorage::Blob', optional: true

  validates :filename, presence: true
  validates :status, presence: true

  enum :status, { pending: 0, processing: 1, completed: 2, failed: 3 }

  has_many :debts
end
