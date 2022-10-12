# frozen_string_literal: true

# Класс, позволяющий делать различные вычисления на стороне исполняемого модуля
module Substitutions
  # noinspection SpellCheckingInspection
  class Calculate < Base
    OPERATION_VALUES = %w(sum percent request_number)

    attr_accessor :operation, :values
    validates :operation, inclusion: { in: OPERATION_VALUES,
                                      message: "%{value} не верное значение. Допустимые значения: #{OPERATION_VALUES}" }

    validates :values, presence: true

    def initialize(*args)
      raise ArgumentError,
            "Количество аргументов функции #{human_name} должно быть не меньше 2" if args.count < 2

      hash_attributes = {}
      hash_attributes[:operation] = args[0]
      hash_attributes[:values] = args[1..-1]
      super(hash_attributes)
      self.attributes=hash_attributes # Этот вызов нужен, чтобы была возможность переопределить attributes=
    end


    def human_description
      'Позволяет выполнять различные арифметические действия. Параметры: '
    end

    def map_arguments
      [:operation, :values]
    end

    def calculate
      "$calculate(#{operation}, #{values.join(', ')})"
    end
  end
end