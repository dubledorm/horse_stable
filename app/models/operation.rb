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


  OPERATION_TYPES = %w(check do next)

  validates :operation_type, :number, :function_name, presence: :true
  validates :number, uniqueness: { scope: [:experiment_case, :operation_type] }
  validates :operation_type, inclusion: { in: OPERATION_TYPES,
                                          message: "Поле operation_type может содержать значения: check, do,next. %{value} это не корректное значение" }
  validates :function_name, inclusion: { in: Functions::Factory::NAME_TO_CLASS.keys,
                                          message: "Поле function_name содержит не корректное значение" }


  belongs_to :experiment_case
  has_one :experiment, through: :experiment_case
  has_many :test_tasks, dependent: :destroy

  scope :check, -> { where(operation_type: 'check').order(:number) }
  scope :do, -> { where(operation_type: 'do').order(:number) }
  scope :next, -> { where(operation_type: 'next').order(:number) }

  def as_json(functions_translate: false)
    if functions_translate
      function = Functions::Factory.build!(function_name, JSON.parse(operation_json || '{}'))
      return function.translate_attributes.stringify_keys
    end

    JSON.parse(operation_json || '{}').stringify_keys
  end

  def self.options_for_select_type
    OPERATION_TYPES.map{|operation_type| [I18n.t("operation.operation_type.#{operation_type}"), operation_type]}
  end
end
