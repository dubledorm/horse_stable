class Experiment < ApplicationRecord

  belongs_to :user
  has_many :experiment_cases

  validates :state, :human_name, presence: :true


  def as_json
    { human_name: human_name,
      human_description: human_description,
      **experiment_cases_hash
    }.stringify_keys
  end

  def experiment_cases_hash
    experiment_cases.order(:number).inject({}) do |result, experiment_case|
      result.merge({ "#{experiment_case.number}".to_sym => experiment_case.as_json })
    end.stringify_keys
  end
end
