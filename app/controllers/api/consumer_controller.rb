module Api
  class ConsumerController < Api::BaseController
    include MbuExample

    def i_am_free
      Rails.logger.info('Get I am free')

      render json: { job_status: :job,
                     job_id: 1,
                     test: MbuExample::COMMAND_HASH_YANDEX }.to_json
    end
  end
end