# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Front::TestEnvironmentsController, type: :request do

  describe 'index#' do
    let!(:project) { FactoryGirl.create :project }
    let(:subject) { get(front_project_test_environments_path(project_id: project.id)) }

    context 'when test_environments does not exist' do
      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it {
        expect(JSON.parse(response.body)).to eq([])
      }
    end

    context 'when test_environments exists' do
      let!(:test_environment1) { FactoryGirl.create :test_environment, project: project }
      let!(:test_environment2) { FactoryGirl.create :test_environment, project: project }

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it {
        expect(JSON.parse(response.body)).to eq([test_environment1.as_json,
                                                 test_environment2.as_json])
      }
    end
  end
end
