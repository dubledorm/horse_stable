class Experiment < ApplicationRecord
  include HumanAttributeValue
  include ExperimentJsonConcern
  include TaggableConcern
  include CategoryConcern
  include UserGroupConcern

  STATE_VALUES = %w[new draft locked]
  FIELD_NAME_VALUES_RELATIONS = { state: STATE_VALUES }

  belongs_to :user
  has_many :experiment_cases, dependent: :destroy
  has_many :operations, through: :experiment_cases
  has_many :test_tasks, dependent: :destroy
  has_many :experiment_to_user_groups, dependent: :destroy
  has_many :user_groups, through: :experiment_to_user_groups

  validates :state, :human_name, presence: :true
  validates :state, inclusion: { in: STATE_VALUES,
                                 message: "Поле state может содержать значения: #{STATE_VALUES.map{ |item| item.to_s }.join(', ')}. %{value} это не корректное значение" }

  scope :human_name, ->(human_name) {  where('human_name LIKE ?', "%#{human_name}%") }
  scope :human_description, ->(human_description) { where('human_description LIKE ?', "%#{human_description}%") }
  scope :state, ->(state) { where(state: state) }
  scope :by_user_id, ->(user_id) { where(user_id: user_id) }
  scope :by_id, ->(id) { where(id: id) }

  def attributes=(hash)
    hash.each do |key, value|
      if key == 'experiment_cases'
        # Обрабатываем массив experiment_cases
        value.each do |experiment_case|
          new_experiment_case = self.experiment_cases.build
          new_experiment_case.from_json(experiment_case.to_json)
        end
      else
        send("#{key}=", value)
      end
    end
  end

  def self.options_for_select_type(field_name)
    FIELD_NAME_VALUES_RELATIONS[field_name].map{|value| [human_attribute_value(field_name, value), value]}
  end

  def last_test_task(user_id)
    self.test_tasks.by_user_id(user_id).completed.descendant_sort.first
  end

  def last_test_tasks(user_id, count)
    self.test_tasks.by_user_id(user_id).state(:completed).descendant_sort.limit(count)
  end

  def variables_sets
    @variables_sets ||= Variables::ArrayOfSets.new(sets_of_variables_json.nil? ? {} : JSON.parse(sets_of_variables_json))
  end
end
