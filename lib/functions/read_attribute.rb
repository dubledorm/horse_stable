module Functions
  class ReadAttribute < BaseSelector

    attr_accessor :attribute_name, :save_as

    def self.attribute_values
      { attribute_name: %w[text]
      }
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [[:selector_name, :selector_value],
       :attribute_name,
       :save_as
      ]
    end

    protected

    def attributes
      super.merge('attribute_name' => self.attribute_name,
                  'save_as' => self.save_as)
    end
  end
end