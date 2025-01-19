FactoryBot.define do
  factory :file_processing do
    filename { "debts_#{Time.current.to_i}.csv" }
    status { 'pending' }

    trait :processing do
      status { 'processing' }
      started_at { Time.current }
    end

    trait :completed do
      status { 'completed' }
      started_at { 1.hour.ago }
      completed_at { Time.current }
    end

    trait :failed do
      status { 'failed' }
      started_at { 1.hour.ago }
      error_message { 'Failed to process file' }
    end
  end
end
