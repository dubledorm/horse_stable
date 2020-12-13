module Front
  class FunctionsController < ActionController::API

    rescue_from Exception, :with => :render_500
    rescue_from ActionController::ParameterMissing, :with => :render_400
    rescue_from ActionController::BadRequest, :with => :render_400

    # внутрення ошибка сервера. не обработанная ошибка
    def render_500(e)
      Rails.logger.error(e.message)
      render json: { message: e.message }.to_json, status: :internal_server_error
    end

    # ошибка в параметрах запроса
    def render_400(e)
      Rails.logger.error(e.message)
      render json: { message: e.message.encode("UTF-8") }.to_json, status: :bad_request
    end

    # Возвращает списиок параметров по имени функции, таких как возможные значения аттрибутов и порядок следования аттрибутов
    def get_parameters
      function = get_function
      render json: { attributes: Hash[*function.short_attribute_names
                                           .map{ |attribute| [attribute,
                                                              function.class.human_attribute_name(attribute)]}
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