# encoding: UTF-8
module GradeConstConcern
  extend ActiveSupport::Concern

  # Если меняется GRADE_TYPES, то надо изменить human_attribute_value.ru.yml,
  # чтобы типы нормально отображались функцией human_attribute_value(:grade_type)
  GRADE_TYPES = %w(quality interestingness politeness).freeze
  GRADE_RANGE = 10

  included do

    validates :grade_type, presence: true, inclusion: { in: GRADE_TYPES }
    validates :grade_value, allow_nil: true, numericality: { greater_than: 0, less_than_or_equal_to: GRADE_RANGE, only_integer: true }
  end
end
