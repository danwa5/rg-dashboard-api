FactoryBot.define do
  factory :user do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email { Faker::Internet.email(name: name, separators: '.') }
    password { Faker::Alphanumeric.alphanumeric(number: 6) }
    password_confirmation { password }
  end

  factory :watchlist do
    association :user
    sequence(:name) { |n| "Watchlist ##{n}" }
    stocks { $COMPANIES.keys.sample((0..15).to_a.sample) }
  end
end
