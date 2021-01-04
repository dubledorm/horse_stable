class Experiment < ApplicationRecord
  include HumanAttributeValue
  include ExperimentJsonConcern

  STATE_VALUES = %w[new draft locked]
  FIELD_NAME_VALUES_RELATIONS = { state: STATE_VALUES }

  belongs_to :user
  has_many :experiment_cases
  has_many :test_tasks

  validates :state, :human_name, presence: :true
  validates :state, inclusion: { in: STATE_VALUES,
                                 message: "Поле state может содержать значения: #{STATE_VALUES.map{ |item| item.to_s }.join(', ')}. %{value} это не корректное значение" }

  scope :human_name, ->(human_name) {  where('human_name LIKE ?', "%#{human_name}%") }
  scope :human_description, ->(human_description) { where('human_description LIKE ?', "%#{human_description}%") }
  scope :state, ->(state) { where(state: state) }
  scope :by_user_id, ->(user_id) { where(user_id: user_id) }
  scope :by_id, ->(id) { where(id: id) }

  def self.options_for_select_type(field_name)
    FIELD_NAME_VALUES_RELATIONS[field_name].map{|value| [human_attribute_value(field_name, value), value]}
  end

  def last_test_task(user_id)
    self.test_tasks.by_user_id(user_id).state(:completed).descendant_sort.first
  end

  def last_test_tasks(user_id, count)
    self.test_tasks.by_user_id(user_id).state(:completed).descendant_sort.limit(count)
  end
end
