module Functions
  class ElementNotFound < StandardError; end;
  class TestInterrupted < StandardError; end;

  FIND_ELEMENT_TIMEOUT = 5

  class Base
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    attr_accessor :human_name, :human_description, :function_name

    validates :function_name, presence: true

    SERVICE_FIELDS = %w[human_name human_description function_name].freeze


    def initialize(hash_attributes = {})
      super(hash_attributes)
      self.attributes=hash_attributes
    end

    def attributes=(hash)
      hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    # Список атрибутов для отображения на форме ввода
    def short_attribute_names
      attribute_names.reject{ |name| SERVICE_FIELDS.include?(name) }
    end

    # Возможные значения атрибутов
    def attribute_values
      {}
    end

    # Порядок вывода атрибутов на форме
    def attribute_orders
      {}
    end

    protected

    # Список атрибутов для сериализации
    def attributes
      { 'human_name' => self.human_name,
        'human_description' => self.human_description,
        'function_name' => self.function_name
      }
    end

    # Общий спсиок имён всех атрибутов
    def attribute_names
      self.class.instance_methods.find_all{ |item| item =~ /\w.*=$/ }
          .reject{ |item| item == 'attributes='.to_sym }
          .map{ |item| item.to_s.gsub('=', '') }
    end
  end
end