module Functions
  class LoadFile < BaseSelector
    #include Rails.application.routes.url_helpers

    attr_accessor :file_id, :file_url
    validates :file_id, numericality: { only_integer: true }, allow_blank: false
    validates :file_url, presence: true


    def attributes=(hash)
      return unless hash
      super
      self.file_url = build_file_url
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [[:selector_name, :selector_value],
       :file_id
      ]
    end

    def self.attribute_hints
      super.merge({ 'file_id' => self.i18n_translate_path('file_id_hint') })
    end

    def short_attribute_names
      super.reject{ |name| name == 'file_url' }
    end

    protected

    def attributes
      super.merge('file_id' => self.file_id,
                  'file_url' => self.file_url)
    end

    private

    def build_file_url
      return unless file_id
      some_file = SomeFile.find(file_id)
      if some_file.file.attached?
        Rails.application.routes.url_helpers.rails_blob_path(some_file.file, only_path: true)
      else
        raise ArgumentError, "Не присоединён файл к записи с id: #{file_id}"
      end
    rescue ActiveRecord::RecordNotFound
      raise ArgumentError, "Не могу найти файл с id: #{file_id}"
    end
  end
end