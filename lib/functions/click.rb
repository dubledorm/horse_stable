module Functions
  class Click < Base

    attr_accessor :selector_name, :selector_value, :selector
    validates :selector_name, :selector, presence: true

    def attributes=(hash)
      hash.each do |key, value|
        if key.to_s == 'selector'
          self.selector = value
          selector_parse = JSON.parse(value || '{}').flatten
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

    protected

    def attributes
      super.merge( 'selector' => build_selector)
    end

    private

    def build_selector
      return nil unless self.selector_name
      { self.selector_name => (self.selector_value || '') }.to_json
    end
  end
end