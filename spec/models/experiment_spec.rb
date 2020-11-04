require 'rails_helper'

RSpec.describe Experiment, type: :model do
  describe 'factory' do
    let!(:experiment) {FactoryGirl.create :experiment}

    # Factories
    it { expect(experiment).to be_valid }

    it { should belong_to(:user) }
    it { should have_many(:experiment_cases) }
  end

  describe 'serialializable' do
    let!(:experiment) {FactoryGirl.create :experiment}
    let!(:result) { { 'experiment_cases' => {},
                            'human_description' => nil,
                            'human_name' => experiment.human_name } }

    it { expect(JSON.parse(Serializable::Experiment.to_json(experiment))).to eq(result) }
  end
end
