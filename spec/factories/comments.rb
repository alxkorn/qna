FactoryBot.define do
  factory :comment do
    user { nil }
    commentable { nil }
    body { "MyString" }

    trait :invalid do
      body { nil }
    end
  end
end
