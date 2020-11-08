module Functions
  class SendText < BaseSelector

    attr_accessor :value, :value_from_storage, :send_return

    protected

    def attributes
      super.merge('value' => self.value,
                  'value_from_storage' => self.value_from_storage,
                  'send_return' => self.send_return)
    end
  end
end