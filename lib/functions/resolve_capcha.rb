module Functions
  class ResolveCapcha < Base

    attr_accessor :storage_src_name, :save_result_as

    protected

    def attributes
      super.merge('storage_src_name' => self.storage_src_name,
                  'save_result_as' => self.save_result_as)
    end
  end
end