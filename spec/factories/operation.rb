FactoryGirl.define do
  factory :operation, class: Operation do
    operation_type 'do'
    sequence(:number) { |n| n}
    experiment_case
  end
end