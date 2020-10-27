module Functions
  class Factory

    NAME_TO_CLASS = { 'click' => Functions::Click,
                      # 'byebug' => Functions::ByeBug,
                      # 'read_attribute' => Functions::ReadAttribute,
                      # 'resolve_capcha' => Functions::ResolveCapcha,
                      # 'send_text' => Functions::SendText,
                      # 'sleep' => Functions::Sleep,
                      # 'connect' => Functions::Connect,
                      # 'validate' => Functions::Validate,
                      # 'scroll' => Functions::Scroll
    }.freeze

    class FunctionBuildError < StandardError; end;

    def self.build!(function_name, hash_attributes = nil)
      function_class = NAME_TO_CLASS[function_name]
      raise Functions::Factory::FunctionBuildError, "Неизвестное имя функции #{function_name}" unless function_class

      function_class.new(hash_attributes.merge('function_name' => function_name))
    end
  end
end