FactoryBot.define do
  factory :debt do
    name { Faker::Name.name }
    government_id { Faker::Number.number(digits: 11).to_s }
    email { Faker::Internet.email }
    amount { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    due_date { Faker::Date.forward(days: 30) }
    debt_id { SecureRandom.uuid }

    before(:create) do |debt|
      debt.file_processing ||= create(:file_processing)
    end

    trait :with_bill do
      after(:create) do |debt|
        create(:bill, debt: debt, status: :pending)
      end
    end

    trait :with_cpf do
      government_id { Faker::Number.number(digits: 11).to_s }
    end

    trait :with_cnpj do
      government_id { Faker::Number.number(digits: 14).to_s }
    end
  end
end
