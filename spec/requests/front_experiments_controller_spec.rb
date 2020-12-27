# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Front::ExperimentsController, type: :request do

  describe 'experiment_current_state#' do
    let!(:user1) { FactoryGirl.create :user }


    context 'when TestTask does not exist' do
      let(:experiment) { FactoryGirl.create :experiment }
      let(:subject) { get(front_experiment_current_state_path, params: { id: experiment.id, user_id: user1.id }) }

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it {
        expect(JSON.parse(response.body)).to eq('started_tasks' => [],
                                                'query_tasks' => [])
      }
    end

    context 'when TestTask exists' do
      let!(:user2) { FactoryGirl.create :user }
      let!(:experiment) { FactoryGirl.create :experiment, user: user2 }
      let!(:test_task_started1) do
        FactoryGirl.create :test_task, state: 'started',
                                                     experiment: experiment,
                                                     user: user1,
                                                     start_time: Time.now - 1.minute
      end
      let!(:test_task_started2) do
        FactoryGirl.create :test_task, state: 'started',
                                                     experiment: experiment,
                                                     user: user2,
                                                     start_time: Time.now - 1.minute
      end
      let!(:test_task_started3) do
        FactoryGirl.create :test_task, state: 'new',
                                                     experiment: experiment,
                                                     user: user2,
                                                     start_time: Time.now + 1.minute
      end
      let!(:test_task_started4) do
        FactoryGirl.create :test_task, state: 'new',
                                                     experiment: experiment,
                                                     user: user2,
                                                     start_time: Time.now + 1.minute
      end

      let(:subject) do
        get(front_experiment_current_state_path, params: { id: experiment.id,
                                                           user_id: user2.id })
      end

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it {
        expect(JSON.parse(response.body)).to eq('started_tasks' => [{ 'id' => test_task_started2.id,
                                                                      'start_time' => test_task_started2.start_time.to_s }],
                                                'query_tasks' => [{ 'id' => test_task_started3.id,
                                                                    'start_time' => test_task_started3.start_time.to_s },
                                                                  { 'id' => test_task_started4.id,
                                                                    'start_time' => test_task_started4.start_time.to_s }])
      }
    end


    context 'when experiment does not exist' do
      let(:subject) { get(front_experiment_current_state_path, params: { id: 1, user_id: user1.id }) }

      before :each do
        subject
      end

      it { expect(response).to have_http_status(404) }
    end
  end
end
