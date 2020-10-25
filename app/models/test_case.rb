class TestCase < ApplicationRecord
  belongs_to :user

  validates :human_name, presence: :true
end
