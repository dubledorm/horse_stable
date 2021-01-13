FactoryGirl.define do
  factory :tag, class: Tag do
    tag_type 'ordinal'
    sequence(:name) { |n| "name#{n}" }
    user
  end

  factory :tag_category, class: Tag do
    tag_type 'category'
    sequence(:name) { |n| "category#{n}" }
    user
  end
end