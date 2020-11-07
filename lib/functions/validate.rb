module Functions
  class Validate < BaseSelector

    attr_accessor :attribute, :value

    protected

    def attributes
      super.merge( 'attribute' => self.attribute,
                   'value' => self.value)
    end
  end
end