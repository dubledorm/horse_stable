# encoding: utf-8
# frozen_string_literal: true

module UserCabinet
  class UserGroupsController < PrivateAreaController
    add_breadcrumb I18n.t('user_groups'), :user_cabinet_user_groups_path, only: [:show]

    def new
      super do
        @resource = UserGroup.new
      end
    end

    def create
      super do
        @resource = UserGroup.create(user_group_params.merge!(user_id: current_user.id))
        unless @resource.persisted?
          render :new
          return
        end
        redirect_to user_cabinet_user_group_path(id: @resource.id)
      end
    end

    def update
      super do
        @resource.update(user_group_params)
        if @resource.errors.count == 0
          render json: attributes_mask_to_json(@resource, user_group_params), status: :ok
        else
          render json: @resource.errors.full_messages.join(', '), status: :unprocessable_entity
        end
      end
    end

    def destroy
      super do
        ActiveRecord::Base.transaction do
          @resource.destroy!
        end
        redirect_to user_cabinet_user_groups_path
      end
    end

    private

    def user_group_params
      params.required(:user_group).permit(:name)
    end
  end
end
