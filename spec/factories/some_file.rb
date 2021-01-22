FactoryGirl.define do
  factory :some_file, :class=>SomeFile do |s|
    sequence(:name) {|n| "some_file_name#{n}" }
    user
  end
end
