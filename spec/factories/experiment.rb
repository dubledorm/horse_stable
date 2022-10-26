FactoryGirl.define do
  factory :experiment, class: Experiment do
    sequence(:human_name) { |n| "human_name#{n}" }
    state :new
    user
    project
  end

  factory :experiment_with_operations, parent: :experiment do
    experiment_cases { [FactoryGirl.create(:experiment_case_with_operations)] }
  end
end