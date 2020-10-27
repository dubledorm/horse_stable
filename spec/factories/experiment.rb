FactoryGirl.define do
  factory :experiment, class: Experiment do
    sequence(:human_name) { |n| "human_name#{n}" }
    state :new
    user
  end
end