# encoding: utf-8

module UserCabinet
  class ExperimentCasesController < PrivateAreaController
    add_breadcrumb Experiment.model_name.human(count: 3), :user_cabinet_experiments_path, only: [:show]

    def show
      super do
        experiment = @resource.experiment.decorate
        @last_test_task = experiment.last_test_task(current_user.id)
        add_breadcrumb experiment.human_name, user_cabinet_experiment_path(id: experiment.id)
      end
    end

    def clone
      get_resource
      raise CanCan::AccessDenied unless can? :clone, @resource

      experiment_case = @resource.clone
      experiment_case.save!
      redirect_to user_cabinet_experiment_path(id: params[:experiment_id])
    end

    def new
      super do
        @resource = ExperimentCase.new
        @resource.number = ExperimentCase::NextCaseNumber.find(params[:experiment_id])
      end
    end

    def create
      super do
        experiment = Experiment.find(params[:experiment_id])
        if experiment&.project.project_to_users.where(user_id: current_user.id, access_right: 'developer').count.zero?
          raise CanCan::AccessDenied
        end

        @resource = ExperimentCase.create(experiment_case_params.merge!(experiment_id: params[:experiment_id],
                                                                        user_id: current_user.id))
        unless @resource.persisted?
          render :new
          return
        end
        redirect_to user_cabinet_experiment_experiment_case_path(id: @resource.id, experiment_id: params[:experiment_id])
      end
    end

    def update
      super do
        @resource.update(experiment_case_params)
        if @resource.errors.count == 0
          render json: attributes_mask_to_json(@resource, experiment_case_params),  status: :ok
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
        redirect_to user_cabinet_experiment_path(id: params[:experiment_id])
      end
    end

    private

    def experiment_case_params
      params.required(:experiment_case).permit(:human_name, :human_description, :number)
    end

    def menu_action_items
      ['experiments']
    end
  end
end