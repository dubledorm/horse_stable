# frozen_string_literal: true
# encoding: utf-8

module Front
  class TestEnvironmentsController < Front::BaseController

    def index
      render json: project.test_environments.as_json
    end

    private

    def project
      @project ||= Project.find(params.required(:project_id))
    end

    def test_environment
      TestEnvironment.find(params.required(:id))
    end
  end
end
