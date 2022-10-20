# frozen_string_literal: true

FactoryGirl.define do
  factory :user_to_user_group, class: UserToUserGroup do |au|
    user_group
    user
  end
end
