FactoryBot.define do
  factory :source do
    name { "Касса организации" }
    external_id { "1234-abcd-f4f4-0987" }
  end

  factory :cashbox do
    name { 'Основная UAH' }
  end

  factory :bank_account do
    name { 'Основной в Банк1' }
  end

  factory :user, aliases: %i[author responsible] do
    sequence(:login, 10) { |n| "user#{n}" }
    email { "#{login}@example.com" }
  end

  factory :expense do
    from_cashbox
    sum { BigDecimal('500.00') }
    author

    trait :from_cashbox do
      association :source, factory: :cashbox
    end

    trait :from_bank_account do
      association :source, factory: :bank_account
    end
  end

  factory :api_user do
    name { 'Учетная система' }
  end
end
