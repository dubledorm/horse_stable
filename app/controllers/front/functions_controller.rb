module Front
  class FunctionsController < Front::BaseController

    # Возвращает списиок параметров по имени функции, таких как возможные значения аттрибутов и порядок следования аттрибутов
    def get_parameters
      function = get_function
      render json: { attributes: Hash[*function.short_attribute_names
                                           .map{ |attribute| [attribute,
                                                              function.class.human_attribute_name(attribute)]}
                                           .flatten],
                     attribute_hints: Hash[*function.short_attribute_names
                                                 .map{ |attribute| [attribute,
                                                                    function.class.attribute_hints[attribute]]}
                                                 .flatten],
                     attribute_values: function.class.attribute_values,
                     attribute_orders: function.class.attribute_orders }
    end

  private

    def get_function
      Functions::Factory.build!(params.required(:name))
    end
  end
end