# encoding: utf-8

module UserCabinet
  class CategoriesController < PrivateAreaController
    add_breadcrumb I18n.t('categories'), :user_cabinet_categories_path, only: [:show]

    def new
      super do
        @resource = Tag.new
      end
    end

    def create
      super do
        @resource = Tag.create(categories_params.merge!(tag_type: 'category',
                                                        user: current_user,
                                                        name: categories_params[:title]))
        unless @resource.persisted?
          render :new
          return
        end
        redirect_to user_cabinet_categories_path
      end
    end

    def update
      super do
        @resource.update(categories_params)
        if @resource.errors.count == 0
          render json: attributes_mask_to_json(@resource, categories_params),  status: :ok
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
        redirect_to user_cabinet_categories_path
      end
    end

    def categories_params
      params.required(:tag).permit(:title)
    end

    def get_resource_class
      Tag
    end
  end
end