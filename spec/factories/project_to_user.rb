# frozen_string_literal: true

FactoryGirl.define do
  factory :project_to_user, class: ProjectToUser do |au|
    project
    user
    access_right :developer
  end
end
