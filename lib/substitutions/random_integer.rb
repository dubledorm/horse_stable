# frozen_string_literal: true

module Substitutions
  class RandomInteger < Base
    include ActiveModel::Model

    attr_accessor :min_value, :max_value
    validates :min_value, :max_value, numericality: { only_integer: true }
    validate :min_value_greater_than_max_value

    def min_value_greater_than_max_value
      if min_value >= max_value
        errors.add(:min_value, 'Должно быть меньше чем max_value')
        errors.add(:max_value, 'Должно быть больше чем min_value')
      end
    end

    def initialize(*args)
      super
      @min_value ||= 0
      @max_value ||= 10
    end

    def min_value=(value)
      @min_value = value.to_i
    end

    def max_value=(value)
      @max_value = value.to_i
    end

    def human_description
      'Возвращает случайное целое число в указанном интервале min и max (границы включаятся)'
    end

    def map_arguments
      [:min_value, :max_value]
    end

    def calculate
      rand(min_value..max_value)
    end
  end
end