# frozen_string_literal: true
# encoding: utf-8

module UserCabinet
  class ExperimentsController < PrivateAreaController
    has_scope :human_name
    has_scope :human_description
    has_scope :state
    has_scope :by_id, as: :id
    has_scope :by_category, as: :category
    has_scope :by_project_id, as: :project_id
    has_scope :by_user_id, as: :user

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
        project = Project.find(experiment_params[:project_id])
        if project.project_to_users.where(user_id: current_user.id, access_right: 'developer').count.zero?
          raise CanCan::AccessDenied
        end

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
        if @resource.errors.count.zero?
          render json: attributes_mask_to_json(@resource, experiment_params),  status: :ok
        else
          render json: @resource.errors.full_messages.join(', '), status: :unprocessable_entity
        end
      end
    end

    def add_set_of_variable
      get_resource
      raise CanCan::AccessDenied unless can? :add_set_of_variable, @resource
      new_variable_set = Variables::SetOfVariables.new(human_set_name: params['set_of_variables'])
      if new_variable_set.valid?
        @resource.variables_sets.sets << new_variable_set
        @resource.sets_of_variables_json = @resource.variables_sets.to_json
        @resource.save
        render json: {}, status: 200
      end
      render json: new_variable_set.errors.full_messages.join(', '), status: :unprocessable_entity
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

      render json: ExperimentCategoryPresenter.new.from_experiment(@resource).to_json, status: :ok
    rescue StandardError => e
      render json: e.message, status: :unprocessable_entity
    end

    def update_groups
      get_resource
      raise CanCan::AccessDenied unless can? :update_groups, @resource

      new_user_groups = ExperimentGroupPresenter.new(current_ability).from_json_string(experiment_params[:user_groups]).groups
      old_user_groups = ExperimentGroupPresenter.new(current_ability).from_experiment(@resource).groups

      (old_user_groups - new_user_groups).each do |user_group|
        group = UserGroup.find(user_group[:name])
        raise CanCan::AccessDenied unless group.user_manager?(current_user)

        @resource.delete_user_group(user_group[:name])
      end

      (new_user_groups - old_user_groups).each do |user_group|
        group = UserGroup.find(user_group[:name])
        raise CanCan::AccessDenied unless group.user_manager?(current_user)

        @resource.add_user_group(user_group[:name])
      end

      render json: ExperimentGroupPresenter.new(current_ability).group_list(@resource).to_json, status: :ok
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
      params.required(:experiment).permit(:human_name, :human_description, :categories, :user_groups, :project_id)
    end

    def menu_action_items
      ['experiments']
    end
  end
end
