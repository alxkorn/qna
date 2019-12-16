FactoryBot.define do
  factory :comment do
    user { nil }
    commentable { nil }
    body { "MyString" }
  end
end
