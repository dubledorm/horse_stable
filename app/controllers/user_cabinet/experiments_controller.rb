# encoding: utf-8
module UserCabinet
  class ExperimentsController < PrivateAreaController
    has_scope :human_name
    has_scope :human_description
    has_scope :state
    has_scope :by_id, as: :id
    has_scope :by_category, as: :category

    add_breadcrumb Experiment.model_name.human(count: 3), :user_cabinet_experiments_path


    def show
      super do
        @last_test_task = @resource.last_test_task(current_user.id)
        @last_task_list = @resource.last_test_tasks(current_user.id, 5)
        @started_task_list = @resource.test_tasks.state(:started).limit(5)
        @query_task_list = @resource.test_tasks.state(:new).limit(5)
      end
    end

    def new
      super do
        @resource = Experiment.new
      end
    end

    def create
      super do
        @resource = Experiment.create(experiment_params.merge!(user_id: current_user.id,
                                                               state: :new))
        unless @resource.persisted?
          render :new
          return
        end
        redirect_to user_cabinet_experiment_path(id: @resource.id)
      end
    end

    def update
      super do
        @resource.update(experiment_params)
        if @resource.errors.count == 0
          render json: attributes_mask_to_json(@resource, experiment_params),  status: :ok
        else
          render json: @resource.errors.full_messages.join(', '), status: :unprocessable_entity
        end
      end
    end

    def update_categories
      get_resource
      raise CanCan::AccessDenied unless can? :update_categories, @resource

      new_categories = ExperimentCategoryPresenter.new.from_json_string(experiment_params[:categories]).categories
      old_categories = ExperimentCategoryPresenter.new.from_experiment(@resource).categories

      (old_categories - new_categories).each do |category|
        @resource.delete_category(category[:name])
      end

      (new_categories - old_categories).each do |category|
        @resource.add_category(category[:name])
      end

      render json: ExperimentCategoryPresenter.new.from_experiment(@resource).to_json,  status: :ok
    rescue StandardError => e
      render json: e.message, status: :unprocessable_entity
    end

    def destroy
      super do
        ActiveRecord::Base.transaction do
          @resource.destroy!
        end
        redirect_to user_cabinet_experiments_path
      end
    end

    def clone
      get_resource
      raise CanCan::AccessDenied unless can? :clone, @resource
      experiment = @resource.clone
      experiment.human_name = "#{experiment.human_name} (#{I18n.t('this_is_the_copy')})"
      experiment.save!
      redirect_to user_cabinet_experiments_path
    end
    private

    def experiment_params
      params.required(:experiment).permit(:human_name, :human_description, :categories)
    end

    def menu_action_items
      ['experiments']
    end
  end
end