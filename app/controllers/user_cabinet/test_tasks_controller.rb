# encoding: utf-8
module UserCabinet
  class TestTasksController < PrivateAreaController
    has_scope :result_kod
    has_scope :state
    has_scope :experiment_name
    has_scope :descendant_by_id_sort, default: nil, allow_blank: true
    has_scope :by_id, as: :id

    add_breadcrumb TestTask.model_name.human(count: 3), :user_cabinet_test_tasks_path, only: :show


    def create
      super do
        experiment = Experiment.find(params.required(:test_task).required(:experiment_id))
        @resource = TestTask.create(test_setting_json: experiment.as_json(functions_translate: true).to_json,
                                    plan_start_time: DateTime.now,
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

    def destroy
      super do
        ActiveRecord::Base.transaction do
          @resource.destroy!
        end
        redirect_to user_cabinet_test_tasks_path
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