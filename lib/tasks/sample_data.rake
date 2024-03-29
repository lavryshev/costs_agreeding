require 'faker'

desc 'Load fake data'
task sample_data: ['db:setup', 'fake:users', 'fake:organizations', 'fake:external_apps', 'fake:sources',
                   'fake:expenses', 'fake:restrictions']

namespace :fake do
  desc 'Create fake users'
  task users: :environment do
    User.create(name: 'Admin', email: 'admin@test.com', login: 'admin', password: 'admin',
                password_confirmation: 'admin', is_admin: true)
    10.times do
      login = Faker::Internet.unique.username.gsub(/[^A-Za-z0-9]/, '')
      User.create!(
        name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
        email: Faker::Internet.unique.email,
        login:,
        password: login,
        password_confirmation: login
      )
    end
  end

  desc 'Create fake organizations'
  task organizations: :environment do
    5.times do
      org = Organization.create!(name: Faker::Company.name, externalid: Faker::Internet.uuid)
      3.times do
        Division.create!(name: Faker::Company.department, externalid: Faker::Internet.uuid, organization: org)
      end
    end
  end

  desc 'Create fake external apps'
  task external_apps: :environment do
    ExternalApp.create!(name: 'Accounting', active: true, callback_url: 'http://example.com/api')
  end

  desc 'Create fake sources'
  task sources: :environment do
    5.times do
      name = Faker::Bank.name
      iban = Faker::Bank.iban(country_code: 'UA')
      Source.create!(name: "#{iban} in #{name}", externalid: Faker::Internet.uuid)
    end
    Source.create!(name: 'Cashbox UAH', externalid: Faker::Internet.uuid)
    Source.create!(name: 'Cashbox USD', externalid: Faker::Internet.uuid)
  end

  desc 'Create fake expenses'
  task expenses: :environment do
    50.times do
      division = Division.find_by_id(rand(1..30))
      organization = division.present? ? division.organization : Organization.find(rand(1..5))
      Expense.create!(
        sum: Faker::Number.decimal(l_digits: 5, r_digits: 2),
        description: Faker::Lorem.sentence,
        source: Source.find(rand(1..7)),
        external_app: ExternalApp.first,
        externalid: Faker::Internet.uuid,
        organization:,
        division:
      )
    end
  end

  desc 'Create restrictions'
  task restrictions: :environment do
    ug = UsersGroup.create!(name: 'user group 1')
    UsersGroupMember.create!(users_group: ug, user: User.where(is_admin: false).first)
    UsersGroupMember.create!(users_group: ug, user: User.where(is_admin: false).second)
    OrganizationRestriction.create!(users_group: ug, organization: Organization.second)
    DivisionRestriction.create!(users_group: ug, division: Organization.first.divisions.first)
    DivisionRestriction.create!(users_group: ug, division: Organization.first.divisions.second)
  end
end
