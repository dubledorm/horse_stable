module Functions
  class ElementNotFound < StandardError; end;
  class TestInterrupted < StandardError; end;

  FIND_ELEMENT_TIMEOUT = 5

  class Base
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    attr_accessor :human_name, :human_description, :function_name

    validates :function_name, presence: true


    def attributes=(hash)
      hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    protected

    def attributes
      { 'human_name' => self.human_name,
        'human_description' => self.human_description,
        'function_name' => self.function_name
      }
    end
  end
end