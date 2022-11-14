class Experiment < ApplicationRecord
  include HumanAttributeValue
  include ExperimentJsonConcern
  include TaggableConcern
  include CategoryConcern
  include UserGroupConcern

  STATE_VALUES = %w[new draft locked]

  belongs_to :user
  belongs_to :project
  has_many :project_to_users, through: :project
  has_many :members, class_name: 'User', through: :project_to_users, source: :user
  has_many :experiment_cases, dependent: :destroy
  has_many :operations, through: :experiment_cases
  has_many :test_tasks, dependent: :destroy
  has_many :experiment_to_user_groups, dependent: :destroy
  has_many :user_groups, through: :experiment_to_user_groups
  has_many :experiment_test_environments

  validates :state, :human_name, presence: :true
  validates :state, inclusion: { in: STATE_VALUES,
                                 message: "Поле state может содержать значения: #{STATE_VALUES.map{ |item| item.to_s }.join(', ')}. %{value} это не корректное значение" }

  scope :human_name, ->(human_name) { where('human_name LIKE ?', "%#{human_name}%") }
  scope :human_description, ->(human_description) { where('human_description LIKE ?', "%#{human_description}%") }
  scope :state, ->(state) { where(state: state) }
  scope :by_user_id, ->(user_id) { where(user_id: user_id) }
  scope :by_id, ->(id) { where(id: id) }
  scope :by_project_id, ->(project_id) { where(project_id: project_id) }
  scope :read_only_by_user, ->(user_id) { joins(:project_to_users).where(project_to_users: { user_id: user_id, access_right: 'tester'}) }
  scope :can_manage_by_user, ->(user_id) { joins(:project_to_users).where(project_to_users: { user_id: user_id, access_right: 'developer'}) }

  def attributes=(hash)
    hash.each do |key, value|
      if key == 'experiment_cases'
        # Обрабатываем массив experiment_cases
        value.each do |experiment_case|
          new_experiment_case = experiment_cases.build
          new_experiment_case.from_json(experiment_case.to_json)
        end
      else
        send("#{key}=", value)
      end
    end
  end

  def variables_sets
    @variables_sets ||= Variables::ArrayOfSets.new(sets_of_variables_json.nil? ? {} : JSON.parse(sets_of_variables_json))
  end
end
