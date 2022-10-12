module Functions
  class LoadFile < BaseSelector
    #include Rails.application.routes.url_helpers

    attr_accessor :file_id, :file_body, :base_file_name, :file_extension
    validates :file_id, numericality: { only_integer: true }, allow_blank: false
    validates :file_body, :base_file_name, presence: true


    def attributes=(hash)
      return unless hash
      super
      self.file_body = download_base64_file_body
      self.base_file_name, self.file_extension = read_file_name_and_extension
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
      super.reject{ |name| %w(file_body file_url base_file_name file_extension).include?(name) }
    end

    protected

    def attributes
      super.merge('file_id' => self.file_id,
                  'file_body' => self.file_body,
                  'base_file_name' => self.base_file_name,
                  'file_extension' => self.file_extension)
    end

    private

    def download_base64_file_body
      return unless file_id
      some_file = SomeFile.find(file_id)
      if some_file.file.attached?
        Base64.encode64(some_file.file.download)
      else
        raise ArgumentError, "Не присоединён файл к записи с id: #{file_id}"
      end
    rescue ActiveRecord::RecordNotFound
      raise ArgumentError, "Не могу найти файл с id: #{file_id}"
    end

    def read_file_name_and_extension
      return unless file_id
      some_file = SomeFile.find(file_id)
      if some_file.file.attached?
        [some_file.file.filename.base, some_file.file.filename.extension_with_delimiter]
      else
        raise ArgumentError, "Не присоединён файл к записи с id: #{file_id}"
      end
    rescue ActiveRecord::RecordNotFound
      raise ArgumentError, "Не могу найти файл с id: #{file_id}"
    end
  end
end