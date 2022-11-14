# frozen_string_literal: true

FactoryGirl.define do
  factory :environment_variable, class: EnvironmentVariable do |au|
    sequence(:key) { |n| "key#{n}" }
    sequence(:value) { |n| "value#{n}" }
    experiment_test_environment
  end
end
