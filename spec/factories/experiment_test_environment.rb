# frozen_string_literal: true

FactoryGirl.define do
  factory :experiment_test_environment, class: ExperimentTestEnvironment do |au|
    test_environment { FactoryGirl.create(:test_environment) }
    experiment { FactoryGirl.create(:experiment, project: test_environment.project) }
  end
end
