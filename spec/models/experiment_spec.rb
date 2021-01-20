require 'rails_helper'

RSpec.describe Experiment, type: :model do
  describe 'factory' do
    let!(:experiment) {FactoryGirl.create :experiment}

    # Factories
    it { expect(experiment).to be_valid }

    it { should belong_to(:user) }
    it { should have_many(:experiment_cases) }
    it { should have_many(:operations) }
  end

  describe 'serialializable' do
    let!(:experiment) {FactoryGirl.create :experiment}
    let!(:experiment_case) {FactoryGirl.create :experiment_case, experiment: experiment}
    let!(:result) { { '1' => { 'check' => {}, 'do' => {}, 'human_name' => experiment_case.human_name, 'next' => {}},
                            'human_description' => nil,
                            'human_name' => experiment.human_name } }
    let!(:experiment_with_operations) { FactoryGirl.create :experiment_with_operations }
    let!(:result1) {{ "human_name" => experiment_with_operations.human_name,
                      "human_description" => nil,
                      experiment_with_operations.experiment_cases[0].number.to_s => { "human_name" => experiment_with_operations.experiment_cases[0].human_name,
                                                                                      "check" => { experiment_with_operations.experiment_cases[0].operations.check[0].number.to_s =>
                                                                                                     { "operation_id" => experiment_with_operations.experiment_cases[0].operations.check[0].id,
                                                                                                       "operation_json" => {}
                                                                                                     },
                                                                                                   experiment_with_operations.experiment_cases[0].operations.check[1].number.to_s =>
                                                                                                     { "operation_id" => experiment_with_operations.experiment_cases[0].operations.check[1].id,
                                                                                                       "operation_json" => {}
                                                                                                     },
                                                                                                   experiment_with_operations.experiment_cases[0].operations.check[2].number.to_s =>
                                                                                                     { "operation_id" => experiment_with_operations.experiment_cases[0].operations.check[2].id,
                                                                                                       "operation_json" => { "human_name" => nil,
                                                                                                                             "human_description" => nil,
                                                                                                                             "do" => "click", "selector" => { "xpath" => "123" }
                                                                                                       }
                                                                                                     }
                                                                                      },
                                                                                      "do" => { experiment_with_operations.experiment_cases[0].operations.do[0].number.to_s =>
                                                                                                  { "operation_id" => experiment_with_operations.experiment_cases[0].operations.do[0].id,
                                                                                                    "operation_json" => {}
                                                                                                  }
                                                                                      },
                                                                                      "next" => {}
                      } } }

    it { expect(JSON.parse(experiment.to_json)).to eq(result) }

    it 'only print' do
      ap experiment_with_operations.as_json
    end

    # it '1111' do
    #   puts 'experiment_with_operations: '
    #   ap JSON.parse(experiment_with_operations.to_json)
    #   puts 'result1: '
    #   ap result1
    #   expect(JSON.parse(experiment_with_operations.to_json)).to eq(result1)
    # end
  end

  describe 'last_test_task' do
    let!(:user1) { FactoryGirl.create :user }
    let!(:user2) { FactoryGirl.create :user }
    let!(:experiment) { FactoryGirl.create :experiment }
    let!(:test_task1) { FactoryGirl.create :test_task, state: 'completed', user: user1, experiment: experiment }
    let!(:test_task2) { FactoryGirl.create :test_task, state: 'completed', user: user1, experiment: experiment }
    let!(:test_task3) { FactoryGirl.create :test_task, state: 'completed', user: user2, experiment: experiment }

    it { expect(experiment.last_test_task(user1)).to eq(test_task2) }
  end
end
