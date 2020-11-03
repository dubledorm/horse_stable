FactoryGirl.define do
  factory :experiment_case, class: ExperimentCase do
    sequence(:human_name) { |n| "human_name#{n}" }
    sequence(:number) { |n| n}
    user
    experiment
  end
end