FactoryGirl.define do
  factory :test_case, class: TestCase do
    sequence(:human_name) { |n| "human_name#{n}" }
    sequence(:number) { |n| n}
    user
  end
end