# encoding: utf-8
module UserCabinet
  class TestTasksController < PrivateAreaController

    def create
      super do
        experiment = Experiment.find(params.required(:test_task).required(:experiment_id))
        @resource = TestTask.create(test_setting_json: experiment.as_json(functions_translate: true).to_json,
                                    start_time: DateTime.now,
                                    state: :new,
                                    experiment: experiment)
        unless @resource.persisted?
          render 'errors/500'
          return
        end
        redirect_to user_cabinet_experiment_path(id: experiment.id)
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