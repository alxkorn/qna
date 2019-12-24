FactoryBot.define do
  factory :comment do
    user
    commentable { nil }
    body { "MyString" }

    trait :invalid do
      body { nil }
    end
  end
end
