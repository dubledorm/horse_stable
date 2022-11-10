# frozen_string_literal: true

# Класс, определяющий попытку запуска теста.
# Содержит планируемое время запуска, состояние, весь результат
class TestTask < ApplicationRecord
  # Класс для сохранения задания отданного на исполнение в mbu_selenium

  include HumanAttributeValue

  STATE_VALUES = %w[new started completed].freeze
  RESULT_KOD_VALUES = %w[interrupted processed].freeze

  validates :test_setting_json, :state, presence: :true
  validates :state, inclusion: { in: STATE_VALUES,
                                 message: "Поле state может содержать значения:
 #{STATE_VALUES.map(&:to_s).join(', ')}. %{value} это не корректное значение" }
  validates :result_kod, allow_blank: true, inclusion: { in: RESULT_KOD_VALUES,
                                                         message: "Поле state может содержать значения:
 #{RESULT_KOD_VALUES.map(&:to_s).join(', ')}. %{value} это не корректное значение" }


  belongs_to :operation, optional: true
  belongs_to :experiment
  belongs_to :user
  has_one :project, through: :experiment

  has_one_attached :failed_screen_shot # Скрин со сбойной операцией

  scope :for_processing, -> { where(state: :new) }
  scope :completed, -> { where(state: :completed) }
  scope :result_kod, ->(result_kod) {  where(result_kod: result_kod)}
  scope :state, ->(state) { where(state: state) }
  scope :experiment_name, ->(name) { joins(:experiment).where('experiments.human_name LIKE ?', "%#{name}%") }
  scope :by_user_id, ->(user_id) { where(user_id: user_id) }
  scope :descendant_by_id_sort, ->(*) { order(id: :desc) }
  scope :descendant_sort, ->(*) { order(finished_time: :desc, id: :desc) }
  scope :by_id, ->(id) { where(id: id) }

  def success?
    return true if result_kod == 'processed'

    false
  end
end
