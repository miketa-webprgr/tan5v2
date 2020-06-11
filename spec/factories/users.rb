FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com"}
    name {"jiro"}
    profile {"hellooooooo"}
    password {"password"}
    suspended { false}
  end
end

