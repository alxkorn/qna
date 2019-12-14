# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    value { 1 }
    user

    trait :for_question do
      association(:votable, factory: :question)
    end
  end
end
