class Experiment < ApplicationRecord

  belongs_to :user
  has_many :test_cases

  validates :state, presence: :true
end
