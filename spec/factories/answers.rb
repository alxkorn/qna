FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_attached_file do
      files {[fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test1.png'), 'image/png')]}
    end
  end
end
