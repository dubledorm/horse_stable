class TestTask < ApplicationRecord
  # Класс для сохранения задания отданного на исполнение в mbu_selenium

  include HumanAttributeValue

  STATE_VALUES = %w[new started completed]
  RESULT_KOD_VALUES = %w[interrupted processed]


  validates :test_setting_json, :state, presence: :true
  validates :state, inclusion: { in: STATE_VALUES,
                                 message: "Поле state может содержать значения: #{STATE_VALUES.map{ |item| item.to_s }.join(', ')}. %{value} это не корректное значение" }
  validates :result_kod, allow_blank: true, inclusion: { in: RESULT_KOD_VALUES,
                                                         message: "Поле state может содержать значения: #{RESULT_KOD_VALUES.map{ |item| item.to_s }.join(', ')}. %{value} это не корректное значение" }


  belongs_to :operation, optional: true
  belongs_to :experiment
  belongs_to :user

  scope :for_processing, -> {where(state: :new)}
end
