# encoding: utf-8
module UserCabinet
  class ExperimentsController < PrivateAreaController
    has_scope :human_name
    has_scope :human_description
    has_scope :state
    has_scope :by_id, as: :id

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
      params.required(:experiment).permit(:human_name, :human_description)
    end

    def menu_action_items
      ['experiments']
    end
  end
end