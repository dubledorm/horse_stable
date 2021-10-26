module Functions
  class SendText < BaseSelector

    attr_accessor :value, :value_from_storage, :send_return, :symbols_per_second
    validates :value, presence: true, if: Proc.new { |me| me.value_from_storage.blank? }
    validates :value_from_storage, presence: true, if: Proc.new { |me| me.value.blank? }
    validates :symbols_per_second, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true

    def self.attribute_hints
      super.merge({ 'value' => self.i18n_translate_path('value_hint'),
                    'value_from_storage' => self.i18n_translate_path('value_from_storage_hint'),
                    'send_return' => self.i18n_translate_path('send_return_hint'),
                    'symbols_per_second' => self.i18n_translate_path('symbols_per_second_hint'),
                  })
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [[:selector_name, :selector_value],
       [:value, :value_from_storage],
       :send_return,
       :symbols_per_second
      ]
    end

    def self.attribute_values
      super.merge({ send_return: %w[true false].sort
                  })
    end

    protected

    def attributes
      super.merge('value' => self.value,
                  'value_from_storage' => self.value_from_storage,
                  'send_return' => self.send_return,
                  'symbols_per_second' => self.symbols_per_second || 0)
    end
  end
end