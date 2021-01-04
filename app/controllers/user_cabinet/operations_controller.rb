# encoding: utf-8

module UserCabinet
  class OperationsController < PrivateAreaController
    add_breadcrumb Experiment.model_name.human(count: 3), :user_cabinet_experiments_path, only: [:show]

    def new
      super do
        @resource = Operation.new
        @resource.operation_type = params[:operation_type]
        @resource.number = Operation::NextOperationNumber.find(params[:experiment_case_id], params[:operation_type])
      end
    end

    def show
      super do
        @function = Functions::Factory.build!(@resource.function_name)
        @function.attributes = JSON.parse(@resource.operation_json) if @resource.operation_json
        add_breadcrumb @resource.experiment.human_name,
                       user_cabinet_experiment_path(id: @resource.experiment.id)
        add_breadcrumb @resource.experiment_case.human_name,
                       user_cabinet_experiment_experiment_case_path(id: @resource.experiment_case_id,
                                                                    experiment_id: @resource.experiment.id)

      end
    end

    def create
      super do
        @resource = Operation.create(operation_params.merge!(experiment_case_id: params[:experiment_case_id]))
        unless @resource.persisted?
          render :new
          return
        end
        redirect_to user_cabinet_operation_path(id: @resource.id)
      end
    end

    def function_update
      get_resource
      raise CanCan::AccessDenied unless can? :update, @resource

      @function = Functions::Factory.build!(function_name)
      @function.attributes = function_params
      unless @function.valid?
        render json: @function.errors.full_messages.join(', '), status: :unprocessable_entity
        return
      end

      @resource.operation_json = @function.to_json
      @resource.function_name = function_name
      @resource.save!
      render json: attributes_mask_to_json(@function, function_params),  status: :ok
    end

    def update
      super do
        @resource.update(operation_params)
        if @resource.errors.count == 0
          render json: attributes_mask_to_json(@resource, operation_params),  status: :ok
        else
          render json: @resource.errors.full_messages.join(', '), status: :unprocessable_entity
        end
      end
    end

    def destroy
      super do
        experiment_case = @resource.experiment_case
        experiment_case_id = experiment_case.id
        experiment_id = experiment_case.experiment.id
        ActiveRecord::Base.transaction do
          @resource.destroy!
        end
        redirect_to user_cabinet_experiment_experiment_case_path(id: experiment_case_id, experiment_id: experiment_id)
      end
    end

    private

    def operation_params
      params.required(:operation).permit(:number, :operation_type, :function_name)
    end

    def function_name
      params.required('function_name')
    end

    def function_params
      params['params']&.permit(@function.short_attribute_names)
    end

    def menu_action_items
      ['experiments']
    end
  end
end