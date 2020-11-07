module Api
  class TestTasksController < Api::BaseController

    def update
      super do
        @resource.update!(state: 'completed',
                          result_kod: params['status'],
                          result_values_json: params['output']&.to_json,
                          duration: params['duration'],
                          result_message: params[:error_message])
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
  end
end