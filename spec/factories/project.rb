# frozen_string_literal: true

FactoryGirl.define do
  factory :project, class: Project do |au|
    sequence(:name) { |n| "project#{n}" }
  end
end
