FactoryBot.define do
  factory :user do
    username { "johndoe" }
    password { "password123" }
    encrypted_password { "password123" }
  end
end
