# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '123456' }
    password_confirmation { '123456' }

    trait :admin do
      admin { true }
    end
  end
end
