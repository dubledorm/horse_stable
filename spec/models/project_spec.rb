# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'factory' do
    let!(:project) { FactoryGirl.create :project }

    # Factories
    it { expect(project).to be_valid }

    it { should validate_presence_of(:name) }
    it { should have_many(:experiments) }
    it { should have_many(:user_groups) }
  end
end
