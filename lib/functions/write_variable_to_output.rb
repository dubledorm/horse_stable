module Functions
  class WriteVariableToOutput < Base

    attr_accessor :variable_name, :save_as

    protected

    def attributes
      super.merge('variable_name' => self.variable_name,
                  'save_as' => self.save_as)
    end
  end
end