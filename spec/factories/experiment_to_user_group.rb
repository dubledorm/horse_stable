# frozen_string_literal: true

FactoryGirl.define do
  factory :experiment_to_user_group, class: ExperimentToUserGroup do |au|
    user_group
    experiment
  end
end
