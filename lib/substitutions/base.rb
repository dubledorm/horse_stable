module Substitutions
  class Base
    include ActiveModel::Model

    def human_name
      self.class.name.split('::').last.underscore
    end

    def human_description
      ''
    end

    def calculate
      raise NotImplementedError
    end

    def initialize(hash_attributes = {})
      super(hash_attributes)
      self.attributes=hash_attributes
    end

    def attributes=(hash)
      hash.each do |key, value|
        send("#{key}=", value)
      end
    end
  end
end