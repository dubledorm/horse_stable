FactoryGirl.define do
  factory :operation, class: Operation do
    operation_type 'do'
    sequence(:number) { |n| n}
    function_name 'click'
    experiment_case
  end

  factory :operation_with_function, class: Operation, parent: :operation do
    operation_json Functions::Click.new({ selector_name: 'xpath', selector_value: '//fieldset[17]/button[2]', do: 'click' } ).to_json
  end
end