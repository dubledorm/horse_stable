require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    let!(:user) {FactoryGirl.create :user}
    let!(:user_with_parameters) {FactoryGirl.create :user_with_parameters}


    # Factories
    it { expect(user).to be_valid }
    it { expect(user_with_parameters).to be_valid }

    # Validations
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it { should have_many(:tags_on_objects) }
    it { should have_many(:tags) }
    it { should have_many(:galleries) }
    it { should have_many(:pictures) }
    it { should have_many(:articles) }
    it { should have_many(:grades) }
    it { should have_many(:blogs) }
    it { should have_one(:user_parameter)}

    it { should have_many(:test_tasks) }
  end

  describe 'cascade delete of services' do
    let!(:user) {FactoryGirl.create :user}
    let!(:service1) {FactoryGirl.create :service, user: user}
    let!(:service2) {FactoryGirl.create :service, user: user}

    it { expect{ user.destroy }.to change(Service, :count).by(-2) }
  end

  describe 'taggable' do
    let!(:user1) {FactoryGirl.create :user}
    let!(:user2) {FactoryGirl.create :user}
    let!(:tag1) {FactoryGirl.create :tag, name: 'tag1'}
    let!(:tag2) {FactoryGirl.create :tag, name: 'tag2'}

    before :each do
      user1.tags << tag1
      user2.tags << tag2
      user2.tags << tag1
    end

    it { expect(Tag.count).to eq(2) }
    it { expect(user1.tags.count).to eq(1) }
    it { expect(User.by_tag('tag1').count).to eq(2) }
    it { expect{ user1.add_tag('tag3').to change(Tag, :count).by(1) }}
    it { expect{ user1.add_tag('tag3').to change(user1.tags, :count).by(1) }}

    it { expect{ user1.add_tag('tag2').to change(Tag, :count).by(0) }}
    it { expect{ user1.add_tag('tag2').to change(user1.tags, :count).by(1) }}

    it { expect{ user1.add_tag('tag1').to change(Tag, :count).by(0) }}
    it { expect{ user1.add_tag('tag1').to change(user1.tags, :count).by(0) }}

    it 'should return all tags by name' do
      user1.add_tag('tag4')
      user1.add_tag('tag5')
      ap(user1.tags_names)

      expect(user1.tags_names).to eq('tag1, tag4, tag5')
    end

    it 'should return all tags by title' do
      user1.add_tag('tag4', 'Тэг 4')
      user1.add_tag('tag5', 'Тэг 5')
      ap(user1.tags_titles)

      expect(user1.tags_titles).to eq(', Тэг 4, Тэг 5')
    end

    it 'should delete tag by name' do
      user1.delete_tag('tag1')

      expect(user1.tags_names).to eq('')
    end
  end

  describe 'taggable delete' do
    let!(:user1) {FactoryGirl.create :user}
    let!(:user2) {FactoryGirl.create :user}
    let!(:tag1) {FactoryGirl.create :tag, name: 'tag1'}
    let!(:tag2) {FactoryGirl.create :tag, name: 'tag2'}

    before :each do
      user1.tags << tag1
      user2.tags << tag2
      user1.tags << tag2
    end

    it { expect{ user1.delete_tag('tag1') }.to change(user1.tags, :count).by(-1) }
    it { expect{ user1.delete_tag('tag1') }.to change(Tag, :count).by(-1) }

    it { expect{ user2.delete_tag('tag2') }.to change(user2.tags, :count).by(-1) }
    it { expect{ user2.delete_tag('tag2') }.to change(Tag, :count).by(0) }
  end

  describe 'has_service?#' do
    let!(:user) {FactoryGirl.create :user_with_services}

    it { expect(user.has_service?('github')).to eq(true) }
    it { expect(user.has_service?('facebook')).to eq(true) }
    it { expect(user.has_service?('vkontakte')).to eq(false) }

  end

  describe 'user_parameter' do
    let!(:user_with_parameters) {FactoryGirl.create :user_with_parameters}
    let!(:user) {FactoryGirl.create :user}

    it { expect{ user_with_parameters.destroy }.to change(User, :count).by(-1) }
    it { expect{ user_with_parameters.destroy }.to change(UserParameter, :count).by(-1) }

    it { expect(user.main_description).to eq(nil) }
    it { expect(user_with_parameters.main_description).to eq('description') }

  end
end
