# encoding: utf-8
module UserCabinet
  class ExperimentsController < PrivateAreaController

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

    private

    def experiment_params
      params.required(:experiment).permit(:human_name, :human_description)
    end

    def menu_action_items
      ['experiments']
    end
  end
end