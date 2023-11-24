FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "course#{n}" }
    sequence(:lecturer) { |n| "lecturer#{n}" }
    sequence(:description) { |n| "description#{n}" }
  end
end
