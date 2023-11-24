FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "course #{n}" }
    sequence(:lecturer) { |n| "lecturer #{n}" }
    sequence(:description) { |n| "description #{n}" }

    trait :with_course_details do
      after(:create) do |course|
        create(:chapter, :with_unit, course: course)
      end
    end
  end
end
