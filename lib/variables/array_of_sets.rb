# frozen_string_literal: true

module Variables
   class ArrayOfSets
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    attr_accessor :sets, :active_set_id

    def initialize(hash_attributes = {})
      super(hash_attributes.deep_stringify_keys)
    end

    # Список атрибутов для сериализации
    def attributes
      { 'sets' => self.sets,
        'active_set_id' => self.active_set_id
      }
    end
  end
end