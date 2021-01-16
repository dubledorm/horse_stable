# frozen_string_literal: true

# Класс, выводящий значение переменной
module Substitutions
  # noinspection SpellCheckingInspection
  class Variable < Base

    attr_accessor :variable_name
    validates :variable_name, presence: true

    def human_description
      'Позволяет вывести значение переменной'
    end

    def map_arguments
      [:variable_name]
    end

    def calculate
      "$variable(#{variable_name})"
    end
  end
end