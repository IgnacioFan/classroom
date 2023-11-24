FactoryBot.define do
  factory :chapter do
    association :course

    sequence(:name) { |n| "chapter#{n}" }
    sequence(:sort_key) { |n| n }
  end
end
