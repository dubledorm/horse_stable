class Experiment < ApplicationRecord

  belongs_to :user
  has_many :experiment_cases

  validates :state, :human_name, presence: :true


  def as_json(functions_translate: false)
    { human_name: human_name,
      human_description: human_description,
      **experiment_cases_hash(functions_translate)
    }.stringify_keys
  end

  def experiment_cases_hash(functions_translate = false)
    experiment_cases.order(:number).inject({}) do |result, experiment_case|
      result.merge({ "#{experiment_case.number}".to_sym => experiment_case.as_json(functions_translate: functions_translate) })
    end
  end
end
