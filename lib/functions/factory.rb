module Functions
  class Factory

    NAME_TO_CLASS = { 'click' => Functions::Click,
                      # 'byebug' => Functions::ByeBug,
                      # 'read_attribute' => Functions::ReadAttribute,
                      # 'resolve_capcha' => Functions::ResolveCapcha,
                      # 'send_text' => Functions::SendText,
                      # 'sleep' => Functions::Sleep,
                      'connect' => Functions::Connect,
                      # 'validate' => Functions::Validate,
                      # 'scroll' => Functions::Scroll
    }.freeze

    class FunctionBuildError < StandardError; end;

    def self.build!(function_name, hash_attributes = {})
      function_class = NAME_TO_CLASS[function_name]
      raise Functions::Factory::FunctionBuildError, "Неизвестное имя функции #{function_name}" unless function_class

      function_class.new(hash_attributes.merge('function_name' => function_name))
    end

    def self.options_for_select
      NAME_TO_CLASS.inject([]){ |result, item| result << [item[1].model_name.human, item[0]]}
    end
  end
end