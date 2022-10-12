# frozen_string_literal: true

module Variables
  # Класс определяет набор перемнных, объедмнённых под одним именем
  # Таких наборов может быть несколько в рамках одного теста
  # set_id - уникальный ключ для идентификации набора в рамках одного эксперимента
  # human_set_name - Название для использования пользователем
  # variables - набор ключ - значение, собственно сами переменные
  class SetOfVariables
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    attr_accessor :set_id, :human_set_name, :variables
    validates :set_id, :human_set_name, presence: true

    def initialize(hash_attributes = {})
      self.variables = {}
      super
      self.set_id  = UUIDTools::UUID.random_create.to_s unless self.set_id
    end

    # Список атрибутов для сериализации
    def attributes
      { 'set_id' => self.set_id,
        'human_set_name' => self.human_set_name,
        'variables' => self.variables
      }
    end

    def attributes=(hash)
      return unless hash
      hash.deep_stringify_keys.each do |key, value|
        send("#{key}=", value)
      end
    end
  end
end