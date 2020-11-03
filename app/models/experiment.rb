class Experiment < ApplicationRecord

  belongs_to :user
  has_many :experiment_cases

  validates :state, :human_name, presence: :true
end
