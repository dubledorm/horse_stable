module Functions
  class SendText < BaseSelector

    attr_accessor :value, :value_from_storage, :send_return
    validates :value, presence: true, if: Proc.new { |me| me.value_from_storage.blank? }
    validates :value_from_storage, presence: true, if: Proc.new { |me| me.value.blank? }

    def self.attribute_hints
      super.merge({ 'value' => self.i18n_translate_path('value_hint'),
                    'value_from_storage' => self.i18n_translate_path('value_from_storage_hint'),
                    'send_return' => self.i18n_translate_path('send_return_hint'),
                  })
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [[:selector_name, :selector_value],
       [:value, :value_from_storage],
       :send_return]
    end

    def self.attribute_values
      super.merge({ send_return: %w[true false].sort
                  })
    end

    protected

    def attributes
      super.merge('value' => self.value,
                  'value_from_storage' => self.value_from_storage,
                  'send_return' => self.send_return)
    end
  end
end