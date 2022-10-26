# encoding: utf-8
class PrivateAreaController < ApplicationController
  before_action :authenticate_user!

  def get_collection
    @collection = apply_scopes(get_resource_class.accessible_by(current_ability)).page params[:page]
  end

  def show
    super do
      @read_only = !can?(:update, @resource)
      yield if block_given?
    end
  end
end
