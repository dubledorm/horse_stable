# encoding: utf-8

module UserProfile
  class UsersController < PrivateUserController

    def show
      super do
        @resource = UserProfilePresenter.new(@resource, view_context)
      end
    end

    def update
      super do
        @resource.update(user_profile_params)
        if @resource.errors.count == 0
          presenter = UserProfilePresenter.new(@resource, view_context)
          render json: Hash[*user_profile_params.keys.map{|key| [key, presenter.send(key)]}.flatten],  status: :ok
        else
          render json: @resource.errors.full_messages.joins(', '), status: :unprocessable_entity
        end
      end
    end

    def menu_action_items
      ['user']
    end

    def user_profile_params
      params.required(:user_profile_presenter).permit(:avatar, :nick_name)
    end
  end
end