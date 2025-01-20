FactoryBot.define do
  factory :file_processing do
    status { :pending }
    filename { "debts.csv" }

    trait :with_file do
      after(:build) do |file_processing|
        file_processing.file.attach(
          io: StringIO.new("name,governmentId,email,debtAmount,debtDueDate,debtId\n"),
          filename: file_processing.filename,
          content_type: 'text/csv'
        )
      end
    end

    trait :processing do
      status { :processing }
      started_at { Time.current }
    end

    trait :completed do
      status { :completed }
      started_at { 1.hour.ago }
      completed_at { Time.current }
    end

    trait :failed do
      status { :failed }
      started_at { 1.hour.ago }
      error_message { 'Failed to process file' }
    end
  end
end
