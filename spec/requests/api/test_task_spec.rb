require 'rails_helper'

RSpec.describe TestTask, type: :request do

  describe 'update#' do
    let!(:test_task) { FactoryGirl.create :test_task }

    context 'when task exists' do
      let(:subject) { put(api_test_task_path(test_task), params: { test_task: { statistic: { duration: '30' },
                                                                                errors: { message: '' },
                                                                                result_kod: 'processed',
                                                                                output_values: { result_number: '1234567890'}
                                                                              }
                                                                  })
                     }

      before :each do
        subject
        test_task.reload
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['result_kod']).to eq('processed')}
      it { expect(JSON.parse(response.body)['duration']).to eq(30)}
      it { expect(JSON.parse(response.body)['result_values_json']).to eq({ result_number: '1234567890'}.to_json)}
      it { ap(response.body) }

      it 'should change state to completed' do
        expect(test_task.state).to eq('completed')
      end
    end

    context 'when task does not exist' do
      let(:subject) { put(api_test_task_path(test_task), params: { test_task: { duration: '30',
                                                                                result_kod: 'OK',
                                                                                result_values_json: { result_number: '1234567890'}.to_json
                                                                              }
                                                                 })
                    }

      before :each do
        test_task.destroy
        subject
      end

      it { expect(response).to have_http_status(404) }
    end
  end

  describe 'get_task#' do
    let(:subject) { get(get_task_api_test_tasks_path) }

    context 'when task does not exist' do
      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['job_status']).to eq('idle')}
    end

    context 'when tasks exist' do
      let!(:test_task) { FactoryGirl.create :test_task }

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['job_status']).to eq('job')}
      it { expect(JSON.parse(response.body)['job_id']).to eq(test_task.id)}
      it { expect(JSON.parse(response.body)['test']).to eq(JSON.parse(test_task.test_setting_json))}
    end
  end
end