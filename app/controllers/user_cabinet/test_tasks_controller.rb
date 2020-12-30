# encoding: utf-8
module UserCabinet
  class TestTasksController < PrivateAreaController
    has_scope :result_kod
    has_scope :state
    has_scope :experiment_name
    has_scope :descendant_sort, default: nil, allow_blank: true

    def create
      super do
        experiment = Experiment.find(params.required(:test_task).required(:experiment_id))
        @resource = TestTask.create(test_setting_json: experiment.as_json(functions_translate: true).to_json,
                                    start_time: DateTime.now,
                                    state: :new,
                                    experiment: experiment,
                                    user: current_user)
        unless @resource.persisted?
          render 'errors/500'
          return
        end
        ExperimentChannel.broadcast_to 'ExperimentChannel', { experiment_id: @resource.experiment_id }
        render json: {}, nothing: true, status: 200
      end
    end


    private

    def test_task_params
      params.required(:test_task).permit()
    end

    def menu_action_items
      ['test_tasks']
    end
  end
end