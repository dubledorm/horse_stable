module Functions
  class Connect < Base

    attr_accessor :value
    validates :value, presence: true

    protected

    def attributes
      super.merge( 'value' => self.value )
    end
  end
end