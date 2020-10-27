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


  validates :operation_type, :number, presence: :true
  validates :number, uniqueness: { scope: [:operation_type, :test_case] }
  validates :operation_type, inclusion: { in: %w(check do next),
                                          message: "Поле operation_type может содержать значения: check, do,next. %{value} это не корректное значение" }
  belongs_to :test_case
end
