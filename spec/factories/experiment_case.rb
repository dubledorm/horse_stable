FactoryGirl.define do
  factory :experiment_case, class: ExperimentCase do
    sequence(:human_name) { |n| "human_name#{n}" }
    sequence(:number) { |n| n}
    user
    experiment
  end

  factory :experiment_case_with_operations, parent: :experiment_case do
    operations { [ FactoryGirl.create(:operation, operation_type: 'do'),
                   FactoryGirl.create(:operation, operation_type: 'check'),
                   FactoryGirl.create(:operation, operation_type: 'check', operation_json: {}.to_json),
                   FactoryGirl.create(:operation, operation_type: 'check', function_name: 'click',
                                      operation_json: Functions::Factory.build!('click',
                                                                                { selector_name: 'xpath',
                                                                                                selector_value: '123'}).to_json)] }
  end
end