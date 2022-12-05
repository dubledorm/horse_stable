module Functions
  class BaseSelector < Base

    attr_accessor :selector_name, :selector_value, :selector
    validates :selector_name, :selector, presence: true

    def attributes=(hash)
      return unless hash
      hash.each do |key, value|
        if key.to_s == 'selector'
          self.selector = value
          selector_parse = (value || {}).flatten
          self.selector_name = selector_parse[0]
          self.selector_value = selector_parse[1]
        else
          send("#{key}=", value)
        end
      end

      self.selector = build_selector
    end

    def short_attribute_names
      super.reject{ |name| name == 'selector' }
    end

    def self.attribute_values
      super.merge({ selector_name: %w[class_name id link_text partial_link_text name tag_name xpath css].sort })
    end

    def self.attribute_hints
      super.merge({ 'selector_name' => self.i18n_translate_path('selector_name_hint'),
                    'selector_value' => self.i18n_translate_path('selector_value_hint') })
    end


    protected

    def attributes
      super.merge( 'selector' => build_selector)
    end

    private

    def build_selector
      return nil unless self.selector_name
      { self.selector_name => (self.selector_value || '') }
    end
  end
end