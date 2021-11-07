# frozen_string_literal: true

module Variables
  class SetOfVariables
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    attr_accessor :set_id, :human_set_name, :variables
    validates :set_id, :human_set_name, presence: true

    # Список атрибутов для сериализации
    def attributes
      { 'set_id' => self.set_id,
        'human_set_name' => self.human_set_name,
        'variables' => self.variables
      }
    end
  end
end