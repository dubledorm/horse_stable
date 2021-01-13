# encoding: utf-8

module UserCabinet
  class CategoriesController < PrivateAreaController

    def new
      super do
        @resource = Tag.new
      end
    end

    def create
      super do
        @resource = Tag.create(categories_params.merge!(tag_type: 'ordinal',
                                                        user: current_user,
                                                        name: categories_params[:title]))
        unless @resource.persisted?
          render :new
          return
        end
        redirect_to user_cabinet_categories_path
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