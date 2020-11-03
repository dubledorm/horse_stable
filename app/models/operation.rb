class Operation < ApplicationRecord
  # Класс, описывающий элементарнную операцию
  # Например:
  # '1' => { human_name: 'Проверка стартовой страницы',
  #          selector: { xpath: '//*[@id="text"]' },
  #          do: 'validate',
  #          attribute: :visible,
  #          value: 'TRUE'
  #        }
  #
  # Содержит:
  # number - номер операции
  # operation_type - определяет тип операции, чтобы не вводить дополнительный уровень


  validates :operation_type, :number, :function_name, presence: :true
 # validates :number, uniqueness: { scope: [:experiment_case, :operation_type] }
  validates :operation_type, inclusion: { in: %w(check do next),
                                          message: "Поле operation_type может содержать значения: check, do,next. %{value} это не корректное значение" }
  validates :function_name, inclusion: { in: Functions::Factory::NAME_TO_CLASS.keys,
                                          message: "Поле function_name содержит не корректное значение" }


  belongs_to :experiment_case

  scope :check, -> { where(operation_type: 'check').order(:number) }
  scope :do, -> { where(operation_type: 'do').order(:number) }
  scope :next, -> { where(operation_type: 'next').order(:number) }
end
