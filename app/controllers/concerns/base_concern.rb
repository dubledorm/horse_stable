module BaseConcern
  extend ActiveSupport::Concern

  def get_resource
    @resource = get_resource_class.find(params.required(:id))
  end

  def get_collection
    @collection = apply_scopes(get_resource_class).all.page params[:page]
  end

  def get_resource_class
    controller_name.classify.constantize
  end
end