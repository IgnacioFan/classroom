FactoryBot.define do
  factory :chapter do
    association :course

    sequence(:name) { |n| "chapter #{n}" }
    sequence(:sort_key) { |n| n }

    trait :with_unit do
      after(:create) do |chapter|
        create(:unit, chapter: chapter)
      end
    end
  end
end
