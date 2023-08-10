FactoryBot.define do
  factory :source do
    name { "Касса организации" }
    sequence(:externalid, 1) { |n| n }
  end

  factory :user, aliases: %i[author responsible] do
    sequence(:login, 10) { |n| "user#{n}" }
    email { "#{login}@example.com" }
  end

  factory :expense do
    source
    sum { BigDecimal('500.00') }
    author
  end

  factory :api_user do
    name { 'Учетная система' }
  end
end
