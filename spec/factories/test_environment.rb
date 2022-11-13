# frozen_string_literal: true

FactoryGirl.define do
  factory :test_environment, class: TestEnvironment do |au|
    sequence(:name) { |n| "environment_name#{n}" }
    project
  end
end
