FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    phone { Faker::PhoneNumber.phone_number }
    address { Faker::Address.full_address }
    credit_card_number { Faker::Business.credit_card_number }
    credit_card_network { Faker::Business.credit_card_type }
    email { Faker::Internet.email }
    user
  end
end
