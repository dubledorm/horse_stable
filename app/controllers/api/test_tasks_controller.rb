module Api
  class TestTasksController < Api::BaseController

    def update
      super do
        @resource.update!(test_tasks_params.merge(state: 'completed'))
      end
    end

    def get_task
      Rails.logger.debug('get_task')

      task = TestTask::FindNewJob.find

      if task.present?
        result = { job_status: :job,
                   job_id: task.id,
                   test: JSON.parse(task.test_setting_json).symbolize_keys }
      else
        result = { job_status: :idle }.to_json
      end

      render json: result, status: 200
    end

    private

    def test_tasks_params
      params.require(:test_task).permit(:result_kod, :result_values_json, :duration)
    end
  end
end