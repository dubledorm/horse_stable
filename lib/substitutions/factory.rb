module Substitutions
  # noinspection RubyStringKeysInHashInspection
  class Factory

    NAME_TO_CLASS = { 'phone_number' => Substitutions::PhoneNumber,
                      'random_integer' => Substitutions::RandomInteger,
                      'calculate' => Substitutions::Calculate,
                      'variable' => Substitutions::Variable,
                      'table_element_in_row' => Substitutions::XpathTableElementInRow,
                      'find_sub_string' => Substitutions::FindSubString}.freeze

    class FunctionBuildError < StandardError; end

    def self.build!(function_name, attributes = [])
      function_class = NAME_TO_CLASS[function_name]
      raise Substitutions::Factory::FunctionBuildError, "Неизвестное имя функции #{function_name}" unless function_class

      function_class.new(*attributes)
    end
  end
end