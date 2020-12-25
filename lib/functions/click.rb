module Functions
  class Click < BaseSelector
    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [%i[selector_name selector_value]]
    end
  end
end