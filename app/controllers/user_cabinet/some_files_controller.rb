# encoding: utf-8

module UserCabinet
  class SomeFilesController < PrivateAreaController
    add_breadcrumb SomeFile.model_name.human(count: 3), :user_cabinet_some_files_path, only: [:show]

    def new
      super do
        @resource = SomeFile.new
      end
    end

    def create
      super do
        @resource = SomeFile.create(some_file_params.merge!(user_id: current_user.id))
        unless @resource.persisted?
          render :new
          return
        end
        redirect_to user_cabinet_some_file_path(id: @resource.id)
      end
    end

    def update
      super do
        @resource.update(some_file_params)
        if @resource.errors.count == 0
          render json: attributes_mask_to_json(@resource, some_file_params),  status: :ok
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
        redirect_to user_cabinet_some_files_path
      end
    end

    private

    def some_file_params
      params.required(:some_file).permit(:name, :description, :file)
    end

    def menu_action_items
      ['social']
    end
  end
end