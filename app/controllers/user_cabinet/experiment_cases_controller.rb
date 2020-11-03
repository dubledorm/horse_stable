# encoding: utf-8
module UserCabinet
  class ExperimentCasesController < PrivateAreaController

    def new
      super do
        @resource = ExperimentCase.new
        @resource.number = ExperimentCase::NextCaseNumber.find(params[:experiment_id])
      end
    end

    def create
      super do
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