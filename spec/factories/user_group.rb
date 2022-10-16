# frozen_string_literal: true

FactoryGirl.define do
  factory :user_group, class: UserGroup do |au|
    sequence(:name) { |n| "name#{n}" }
    user
  end
end
