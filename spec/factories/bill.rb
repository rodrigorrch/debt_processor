FactoryBot.define do
  factory :bill do
    association :debt
    status { 'pending' }
    external_id { SecureRandom.uuid }

    trait :generated do
      status { 'generated' }
      generated_at { Time.current }
    end

    trait :sent do
      status { 'sent' }
      generated_at { 1.hour.ago }
      sent_at { Time.current }
    end

    trait :error do
      status { 'error' }
      error_message { 'Failed to generate bill' }
    end
  end
end
