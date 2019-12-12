FactoryBot.define do
  factory :reward do
    name { "MyString" }
    user { nil }
    question { nil }

    trait :with_image do
      image {fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test1.png'), 'image/png')}
    end
  end
end
