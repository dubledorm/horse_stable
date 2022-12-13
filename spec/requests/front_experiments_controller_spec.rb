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

  describe 'experiment_last_result#' do
    let!(:user1) { FactoryGirl.create :user }


    context 'when TestTask does not exist' do
      let(:experiment) { FactoryGirl.create :experiment }
      let(:subject) { get(front_experiment_last_result_path, params: { id: experiment.id, user_id: user1.id }) }

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it {
        expect(JSON.parse(response.body)).to eq('duration' => nil,
                                                'experiment_case_id' => nil,
                                                'id' => nil,
                                                'result_kod' => nil,
                                                'translated_result_kod' => nil,
                                                'result_message' => nil,
                                                'result_values_json' => {},
                                                'start_time' => nil,
                                                'url_screen_shot' => '',
                                                'url_screen_shot_preview' => '')
      }
    end

    context 'when TestTask interrupted' do
      let(:operation) { FactoryGirl.create :operation }

      let!(:test_task) do
        FactoryGirl.create :test_task, state: 'completed',
                           experiment: operation.experiment_case.experiment,
                           result_kod: 'interrupted',
                           state: 'completed',
                           duration: 10,
                           operation_id: operation.id,
                           user: operation.experiment_case.experiment.user,
                           start_time: Time.now - 1.minute
      end

      let(:subject) do
        get(front_experiment_last_result_path, params: { id: operation.experiment_case.experiment_id,
                                                         user_id: operation.experiment_case.experiment.user_id })
      end

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it {
        expect(JSON.parse(response.body)).to eq('duration' => 10,
                                                'experiment_case_id' => operation.experiment_case_id,
                                                'id' => test_task.id,
                                                'result_kod' => 'interrupted',
                                                'translated_result_kod' => 'Прерван',
                                                'result_message' => nil,
                                                'result_values_json' => {},
                                                'start_time' => test_task.start_time.to_s,
                                                'url_screen_shot' => '',
                                                'url_screen_shot_preview' => '')
      }
    end

    context 'when TestTask exists' do
      let!(:user2) { FactoryGirl.create :user }
      let!(:experiment) { FactoryGirl.create :experiment, user: user2 }
      let!(:test_task1) do
        FactoryGirl.create :test_task, state: 'completed',
                           experiment: experiment,
                           user: user1,
                           start_time: Time.now - 1.minute
      end
      let!(:test_task3) do
        FactoryGirl.create :test_task, state: 'new',
                           experiment: experiment,
                           user: user2,
                           start_time: Time.now + 1.minute
      end
      let!(:test_task4) do
        FactoryGirl.create :test_task, state: 'completed',
                           experiment: experiment,
                           user: user2,
                           start_time: Time.now - 11.minute
      end
      let!(:test_task2) do
        FactoryGirl.create :test_task, state: 'completed',
                           experiment: experiment,
                           user: user2,
                           start_time: Time.now - 10.minute,
                           duration: 10,
                           result_kod: 'processed'
      end

      let(:subject) do
        get(front_experiment_last_result_path, params: { id: experiment.id,
                                                         user_id: user2.id })
      end

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it {
        expect(JSON.parse(response.body)).to eq('duration' => 10,
                                                'experiment_case_id' => nil,
                                                'id' => test_task2.id,
                                                'result_kod' => 'processed',
                                                'translated_result_kod' => 'Успешно',
                                                'result_message' => nil,
                                                'result_values_json' => {},
                                                'start_time' => test_task2.start_time.to_s,
                                                'url_screen_shot' => '',
                                                'url_screen_shot_preview' => '')
      }
    end

  end

  describe 'experiment_history_list#' do
    let!(:user1) { FactoryGirl.create :user }

    context 'when TestTask does not exist' do
      let(:experiment) { FactoryGirl.create :experiment }
      let(:subject) { get(front_experiment_history_list_path, params: { id: experiment.id, user_id: user1.id }) }

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)).to eq('history_list' => []) }
    end

    context 'when TestTask exists' do
      let!(:user2) { FactoryGirl.create :user }
      let!(:experiment) { FactoryGirl.create :experiment, user: user2 }
      let!(:test_task1) do
        FactoryGirl.create :test_task, state: 'completed',
                           experiment: experiment,
                           result_kod: 'interrupted',
                           user: user1,
                           start_time: Time.now - 1.minute
      end
      let!(:test_task3) do
        FactoryGirl.create :test_task, state: 'new',
                           experiment: experiment,
                           user: user2,
                           start_time: Time.now + 1.minute
      end
      let!(:test_task4) do
        FactoryGirl.create :test_task, state: 'started',
                           experiment: experiment,
                           result_kod: 'interrupted',
                           user: user2,
                           start_time: Time.now - 11.minute
      end
      let!(:test_task2) do
        FactoryGirl.create :test_task, state: 'completed',
                           experiment: experiment,
                           user: user2,
                           start_time: Time.now - 10.minute,
                           duration: 10,
                           result_kod: 'processed'
      end

      let(:subject) do
        get(front_experiment_history_list_path, params: { id: experiment.id,
                                                         user_id: user2.id })
      end

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it {
        expect(JSON.parse(response.body)).to eq('history_list' => [{ 'id' => test_task2.id,
                                                                     'start_time' => test_task2.start_time.to_s,
                                                                     'state' => 'Выполнен',
                                                                     'result_kod' => 'processed',
                                                                     'translated_result_kod' => 'Успешно' },
                                                                   { 'id' => test_task4.id,
                                                                     'start_time' => test_task4.start_time.to_s,
                                                                     'state' => 'Запущен',
                                                                     'result_kod' => 'interrupted',
                                                                     'translated_result_kod' => 'Прерван' },
                                                                   { 'id' => test_task3.id,
                                                                     'start_time' => test_task3.start_time.to_s,
                                                                     'state' => 'Новый',
                                                                     'result_kod' => nil,
                                                                     'translated_result_kod' => nil }])
      }
    end
  end

  describe 'experiment_test_environments#' do
    context 'when test_environments does not exist' do
      let(:experiment) { FactoryGirl.create :experiment }
      let(:subject) { get(front_experiment_experiment_test_environments_path(experiment_id: experiment.id)) }

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it {
        expect(JSON.parse(response.body)).to eq([])
      }
    end

    context 'when test_environments exists' do
      let!(:experiment) { FactoryGirl.create :experiment }
      let!(:experiment_test_environment1) { FactoryGirl.create :experiment_test_environment, experiment: experiment}
      let(:subject) { get(front_experiment_experiment_test_environments_path(experiment_id: experiment.id)) }

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it {
        expect(JSON.parse(response.body)).to eq([])
      }
    end
  end
end
