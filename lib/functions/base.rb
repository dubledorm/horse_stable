# frozen_string_literal: true

module Functions
  class ElementNotFound < StandardError; end
  class TestInterrupted < StandardError; end

  FIND_ELEMENT_TIMEOUT = 5

  # noinspection RubyStringKeysInHashInspection
  class Base
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    attr_accessor :human_name, :human_description, :do

    validates :do, presence: true

    SERVICE_FIELDS = %w[human_name human_description do].freeze


    def initialize(hash_attributes = {})
      super(hash_attributes)
      self.attributes=hash_attributes
    end

    def attributes=(hash)
      return unless hash
      hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    # Список атрибутов для отображения на форме ввода
    def short_attribute_names
      attribute_names.reject{ |name| SERVICE_FIELDS.include?(name) }
    end

    # Возможные значения атрибутов
    def self.attribute_values
      {}
    end

    # Список подсказок для аттрибутов. Устанавливается hash {name: 'hint value'}
    def self.attribute_hints
      {}
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      []
    end

    # Если в значениях атрибутов используется функция, то перевести в значение функции
    def translate_attributes
      Hash[*attributes.map do |key, value|
        [key, value.class == String && key != 'file_body' ? translate!(value) : value]
      end.flatten]
    end

    protected

    # Список атрибутов для сериализации
    def attributes
      { 'human_name' => self.human_name,
        'human_description' => self.human_description,
        'do' => self.do
      }
    end

    # Общий спсиок имён всех атрибутов
    def attribute_names
      self.class.instance_methods.find_all{ |item| item =~ /\w.*=$/ }
          .reject{ |item| item == 'attributes='.to_sym }
          .map{ |item| item.to_s.gsub('=', '') }
    end

    def self.i18n_translate_path(name)
      I18n.t("activemodel.attributes.#{self.name.underscore}.#{name}")
    end

    private

    REG_FIND_FUNCTIONS = /(^|[^\\]|[\\]{2}+)\$(?<function>[^\s()]+\([^()]*+\))/
    REG_SEPARATE_NAME_ARGS = /(?<prefix>(^|[^\\]|[\\]{2}+))\$(?<name>[^\s()]+)\((?<args>[^()]*)\)/

    # Ищем и заменяем функции в строке value на их значения
    def translate!(value)
      return unless value

      # Цикл по найденным функциям
      value.gsub(REG_FIND_FUNCTIONS) do |function|
        # Разделяем имя функции и аргументы
        m = function.match(REG_SEPARATE_NAME_ARGS)
        raise ArgumentError, "Ошибка разбора аргументов функции #{function}" if m.nil? || m[:name].nil? || m[:args].nil?

        # Применяем функцию
        fnc = Substitutions::Factory.build!(m[:name], m[:args].gsub(' ', '').split(','))
        raise ArgumentError, "Ошибка разбора аргументов функции #{m[:name]} с аргументами #{m[:args]}. Ошибка: #{fnc.errors.full_messages}" unless fnc.valid?

        # вычисляем и заменяем функцию в исходной строке
        "#{m[:prefix]}#{fnc.calculate}"
      end
    end
  end
end