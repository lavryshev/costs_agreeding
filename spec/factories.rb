FactoryBot.define do
  factory :source do
    name { 'Касса организации' }
    sequence(:externalid, 1) { |n| n }
  end

  factory :user, aliases: %i[author responsible] do
    sequence(:login, 10) { |n| "user#{n}" }
    email { "#{login}@example.com" }
  end

  factory :expense do
    external_app
    source
    sum { BigDecimal('500.00') }
  end

  factory :external_app do
    name { 'Учетная система' }
  end
end
