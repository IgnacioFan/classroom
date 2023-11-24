FactoryBot.define do
  factory :unit do
    association :chapter

    sequence(:name) { |n| "unit #{n}" }
    sequence(:description) { |n| "unit #{n} description" }
    sequence(:content) { |n| "unit #{n} content" }
    sequence(:sort_key) { |n| n }
  end
end
