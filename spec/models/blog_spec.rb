require 'rails_helper'

RSpec.describe Blog, type: :model do
  describe 'factory' do
    let!(:blog) {FactoryGirl.create :blog}

    # Factories
    it { expect(blog).to be_valid }

    # Validations
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:post_type) }
    it { should validate_presence_of(:title) }

    it { should have_many(:tags) }
    it { should belong_to(:gallery) }
    it { should belong_to(:user) }
  end

  # Надо раскомментирровать тесты ниже, если мы включаем в Blog работу с elasticsearch
  # describe 'search' do
  #   let!(:blog1) {FactoryGirl.create :blog, title: 'Первый блог', content: 'Это первое содержимое'}
  #   let!(:blog2) {FactoryGirl.create :blog, title: 'Второй блог', content: 'Это второе содержимое'}
  #   let!(:blog3) {FactoryGirl.create :blog, title: '3', content: 'блоги блоги'}
  #   let!(:blog4) {FactoryGirl.create :blog, title: '4', content: 'Заметка на русском языке'}
  #   let!(:blog5) {FactoryGirl.create :blog, title: '5', content: 'Заметки'}
  #
  #   before :each do
  #     Blog.import(force: true)
  #     sleep(3)
  #   end
  #
  #   it { expect(Blog.search('первый').records.count).to eq(1) }
  #   it { expect(Blog.search('Блог').records.count).to eq(3) }
  #   it { expect(Blog.search('блоги').records.count).to eq(3) }
  #   it { expect(Blog.search('заметка').records.count).to eq(2) }
  #   it { expect(Blog.search('заметка язык').records.count).to eq(2) }
  #
  # end
end
