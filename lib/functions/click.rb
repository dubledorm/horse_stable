module Functions
  class Click < Base

    attr_accessor :selector
    validates :selector, presence: true

    protected

    def attributes
     super.merge( 'selector' => self.selector )
    end
  end
end