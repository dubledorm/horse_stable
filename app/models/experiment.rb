class Experiment < ApplicationRecord
  include HumanAttributeValue

  STATE_VALUES = %w[new draft locked]
  FIELD_NAME_VALUES_RELATIONS = { state: STATE_VALUES }

  belongs_to :user
  has_many :experiment_cases
  has_many :test_tasks

  validates :state, :human_name, presence: :true
  validates :state, inclusion: { in: STATE_VALUES,
                                 message: "Поле state может содержать значения: #{STATE_VALUES.map{ |item| item.to_s }.join(', ')}. %{value} это не корректное значение" }

  scope :human_name, -> (human_name){  where('human_name LIKE ?', "%#{human_name}%")}
  scope :human_description, -> (human_description){  where('human_description LIKE ?', "%#{human_description}%")}
  scope :state, -> (state){  where(state: state)}

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

  def self.options_for_select_type(field_name)
    FIELD_NAME_VALUES_RELATIONS[field_name].map{|value| [human_attribute_value(field_name, value), value]}
  end
end
