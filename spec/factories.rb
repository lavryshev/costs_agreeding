FactoryBot.define do
  factory :users_group do
    name { "Наша организация" }
  end

  factory :user, aliases: %i[author responsible] do
    sequence(:login, 10) { |n| "user#{n}" }
    email { "#{login}@example.com" }
  end

  factory :source do
    name { 'Касса организации' }
    sequence(:externalid, 1) { |n| n }
  end

  factory :expense do
    external_app
    sequence(:externalid, 1) { |n| "abc#{n}" }
    organization
    source
    sum { BigDecimal('500.00') }
  end

  factory :external_app do
    name { 'Учетная система' }
  end

  factory :organization do
    name { 'Наша организация' }
    sequence(:externalid, 1) { |n| "abc#{n}" }
  end

  factory :division do
    name { 'IT отдел' }
    sequence(:externalid, 1) { |n| "abc#{n}" }
    organization
  end
end
