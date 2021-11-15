# frozen_string_literal: true

module Variables
   class ArrayOfSets
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    attr_accessor :sets, :active_set_id

    def initialize(hash_attributes = {})
      self.sets = []
      self.attributes=hash_attributes
    end

    def attributes=(hash)
      return unless hash
      hash.deep_stringify_keys.each do |key, value|
        if key == 'sets'
          # Обрабатываем массив sets
          value.each do |set_of_variables|
            self.sets << SetOfVariables.new(set_of_variables)
          end
        else
          send("#{key}=", value)
        end
      end
    end

    # Список атрибутов для сериализации
    def attributes
      { 'sets' => self.sets,
        'active_set_id' => self.active_set_id
      }
    end
  end
end