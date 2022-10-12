# frozen_string_literal: true

# Класс, выводящий значение переменной
module Substitutions
  # noinspection SpellCheckingInspection
  class XpathTableElementInRow < Base

    attr_accessor :table_xpath, :key_word, :text_for_search
    validates :table_xpath, :key_word, :text_for_search, presence: true

    def human_description
      'Найти в строке таблицы по xpath <table_xpath> элемент,содержащий текст <text_for_search>, при условии, что в этой жес троке есть текст <key_word>'
    end

    def map_arguments
      [:table_xpath, :key_word, :text_for_search]
    end

    def calculate
      ''
    end
  end
end