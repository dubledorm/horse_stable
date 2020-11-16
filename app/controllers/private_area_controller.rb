# encoding: utf-8
class PrivateAreaController < ApplicationController
  before_action :authenticate_user!

  def get_resource
    @resource = get_resource_class.find(params.required(:id))
  end

  def get_collection
    @collection = apply_scopes(get_resource_class.accessible_by(current_ability))
  end
end