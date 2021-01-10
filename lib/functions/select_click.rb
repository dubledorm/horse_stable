module Functions
  class SelectClick < BaseSelector

    attr_accessor :option_value, :option_text
    validates :option_value, presence: true, if: Proc.new { |me| me.option_text.blank? }
    validates :option_text, presence: true, if: Proc.new { |me| me.option_value.blank? }


    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [[:selector_name, :selector_value],
       :option_text,
       :option_value
      ]
    end

    def self.attribute_hints
      super.merge({ 'option_text' => self.i18n_translate_path('option_text_hint'),
                    'option_value' => self.i18n_translate_path('option_value_hint') })
    end

    protected

    def attributes
      super.merge('option_text' => self.option_text,
                  'option_value' => self.option_value)
    end
  end
end