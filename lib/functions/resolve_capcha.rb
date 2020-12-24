module Functions
  class ResolveCapcha < Base

    attr_accessor :storage_src_name, :save_result_as
    validates :storage_src_name, :save_result_as, presence: true

    def self.attribute_hints
      super.merge({ 'storage_src_name' => self.i18n_translate_path('storage_src_name_hint'),
                    'save_result_as' => self.i18n_translate_path('save_result_as_hint')})
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [:storage_src_name,
       :save_result_as
      ]
    end

    protected

    def attributes
      super.merge('storage_src_name' => self.storage_src_name,
                  'save_result_as' => self.save_result_as)
    end
  end
end