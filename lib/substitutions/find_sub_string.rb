# frozen_string_literal: true

# Класс, выводящий значение переменной
module Substitutions
  # noinspection SpellCheckingInspection
  class FindSubString < Base

    attr_accessor :source_string, :search_expression
    validates :source_string, :search_expression, presence: true

    def human_description
      'Найти подстроку по регулярному выражению'
    end

    def map_arguments
      [:source_string, :search_expression]
    end

    def calculate
      "$find_sub_string(#{source_string}, #{search_expression})"
    end
  end
end