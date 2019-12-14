FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://www.google.com" }

    trait :invalid do
      url { 'invalid url' }
    end

    trait :gist do
      url { 'https://gist.github.com/alxkorn/26076b45ec43c8e4ea10bb5d32d1f7fc' }
    end
  end
end
