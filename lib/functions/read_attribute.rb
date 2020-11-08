module Functions
  class ReadAttribute < BaseSelector

    attr_accessor :attribute_name, :save_as

    protected

    def attributes
      super.merge('attribute_name' => self.attribute_name,
                  'save_as' => self.save_as)
    end
  end
end