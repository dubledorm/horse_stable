class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_active_menu_items
  include BaseConcern
  include MenuConcern

  unless Rails.env.development?
    rescue_from Exception, with: :render_500
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::ParameterMissing, with: :render_400
    rescue_from ActionController::BadRequest, with: :render_400
    rescue_from ActionController::RoutingError, with: :render_400
    rescue_from CanCan::AccessDenied, with: :render_403
  end

  # Нет прав длядоступа к объекту
  def render_403(e)
    Rails.logger.error(e.message)
    respond_to do |format|
      format.html { render 'errors/403', status: :forbidden }
      format.json { render json: e.message, status: :forbidden }
    end
  end

  # страница не найдена
  def render_404(e)
    Rails.logger.error(e.message)
    respond_to do |format|
      format.html { render 'errors/404', status: :not_found }
      format.json { render json: e.message, status: :not_found }
    end
  end

  # ошибка в параметрах запроса
  def render_400(e)
    Rails.logger.error(e.message)
    respond_to do |format|
      format.html { render 'errors/400', status: :bad_request }
      format.json { render json: e.message, status: :bad_request }
    end
  end

  # внутрення ошибка сервера. не обработанная ошибка
  def render_500(e)
    Rails.logger.error(e.message)
    respond_to do |format|
      format.html { render 'errors/500', status: 500 }
      format.json { render json: e.message, status: :unprocessable_entity }
    end
  end


  def show
    get_resource
    raise CanCan::AccessDenied unless can? :show, @resource

    yield if block_given?
  end

  def index
    #raise CanCan::AccessDenied unless can? :index, get_resource_class

    get_collection
    yield if block_given?
  end

  def new
    raise CanCan::AccessDenied unless can? :new, get_resource_class

    yield if block_given?
  end

  def create
    raise CanCan::AccessDenied unless can? :create, get_resource_class

    yield
  end

  def update
    get_resource
    raise CanCan::AccessDenied unless can? :update, @resource

    yield
  end

  def destroy
    get_resource
    raise CanCan::AccessDenied unless can? :destroy, @resource

    if block_given?
      yield
    else
      ActiveRecord::Base.transaction do
        @resource.destroy!
      end
    end
  end

  def edit
    get_resource
    raise CanCan::AccessDenied unless can? :edit, @resource

    yield if block_given?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar, :nick_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :nick_name])
  end

  def set_active_menu_items
    @active_menu_items = menu_action_items
  end
end
