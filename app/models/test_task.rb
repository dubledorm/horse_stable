class TestTask < ApplicationRecord
  # Класс для сохранения задания отданного на исполнение в mbu_selenium

  include HumanAttributeValue

  STATE_VALUES = %w[new started completed]
  RESULT_KOD_VALUES = %w[interrupted processed]
  FIELD_NAME_VALUES_RELATIONS = { result_kod: RESULT_KOD_VALUES, state: STATE_VALUES }


  validates :test_setting_json, :state, presence: :true
  validates :state, inclusion: { in: STATE_VALUES,
                                 message: "Поле state может содержать значения: #{STATE_VALUES.map{ |item| item.to_s }.join(', ')}. %{value} это не корректное значение" }
  validates :result_kod, allow_blank: true, inclusion: { in: RESULT_KOD_VALUES,
                                                         message: "Поле state может содержать значения: #{RESULT_KOD_VALUES.map{ |item| item.to_s }.join(', ')}. %{value} это не корректное значение" }


  belongs_to :operation, optional: true
  belongs_to :experiment
  belongs_to :user

  has_one_attached :failed_screen_shot # Скрин со сбойной операцией

  scope :for_processing, -> { where(state: :new) }
  scope :result_kod, ->(result_kod) {  where(result_kod: result_kod)}
  scope :state, ->(state) { where(state: state) }
  scope :experiment_name, ->(name) { joins(:experiment).where('experiments.human_name LIKE ?', "%#{name}%") }
  scope :by_user_id, ->(user_id) { where(user_id: user_id) }
  scope :descendant_sort, ->(*) { order(id: :desc) }

  def self.options_for_select_type(field_name)
    FIELD_NAME_VALUES_RELATIONS[field_name].map{|value| [human_attribute_value(field_name, value), value]}
  end

  def success?
    return true if result_kod == 'processed'

    false
  end
end
