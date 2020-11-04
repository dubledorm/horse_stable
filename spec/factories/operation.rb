FactoryGirl.define do
  factory :operation, class: Operation do
    operation_type 'do'
    sequence(:number) { |n| n}
    function_name 'click'
    experiment_case
  end
end