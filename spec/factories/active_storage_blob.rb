FactoryBot.define do
  factory :active_storage_blob, class: 'ActiveStorage::Blob' do
    filename { 'debts.csv' }
    byte_size { 1024 }
    checksum { SecureRandom.hex(32) }
    content_type { 'text/csv' }
    metadata { {} }
    service_name { 'local' }
    key { SecureRandom.uuid }

    after(:build) do |blob|
      blob.upload(StringIO.new(File.read(Rails.root.join('spec/fixtures/files/debts.csv'))))
    end
  end
end
