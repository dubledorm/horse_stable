# encoding: utf-8
class ArticlesController < ApplicationController

  has_scope :by_article_type, as: :article_type
  has_scope :by_state, as: :state
  has_scope :by_user, as: :user_id
  has_scope :greater_than_min_age, as: :min_age
  has_scope :less_than_max_age, as: :max_age
  has_scope :greater_than_min_quantity, as: :min_quantity
  has_scope :less_than_max_quantity, as: :max_quantity

  def new
    super do
      @user = User.find(params.required(:user_id))
      @resource = Article.new(user_id: params.required(:user_id))
    end
  end

  def create
    super do
      @user = User.find(params.required(:user_id))
      @resource = Article.create(article_params)
      unless @resource.persisted?
        render :new
        return
      end
      redirect_to user_article_path(user_id: @user.id, id: @resource.id)
    end
  end

  def update
    super do
      @user = User.find(params.required(:user_id))
      @resource.update(article_params)

      respond_to do |format|
        if @resource.errors.count == 0
          format.html { redirect_to user_article_path(user_id: @user.id, id: @resource.id) }
          format.js
          format.json { render json: @resource, status: :updated, location: @resource }
        else
          format.html { render action: :edit }
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def show
    super do
      @user = User.find(params.required(:user_id))
    end
  end

  private

  def article_params
    params.required(:article).permit(:name, :main_description, :short_description, :state, :article_type,
                                     :min_quantity, :max_quantity, :min_age, :max_age, :seo_description,
                                     :seo_keywords, :duration_minutes, :gallery_id, :user_id)
  end
end
