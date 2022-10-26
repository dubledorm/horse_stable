require 'rails_helper'

# describe Article do
#   describe 'factory' do
#     let!(:article) {FactoryGirl.create :article}
#
#     # Factories
#     it { expect(article).to be_valid }
#
#     # Relationships
#     it { should belong_to(:gallery) }
#     it { should belong_to(:user) }
#     it { should have_many(:tags)}
#
#
#     # Validations
#     it { should validate_presence_of(:name) }
#     it { should validate_presence_of(:state) }
#     it { should validate_presence_of(:article_type) }
#   end
#
#   describe 'scoupes' do
#     let!(:article) {FactoryGirl.create :article}
#     let!(:article1) {FactoryGirl.create :article, article_type: :product}
#     let!(:article2) {FactoryGirl.create :article, state: :draft}
#     let!(:article3) {FactoryGirl.create :article, min_age: 10}
#     let!(:article4) {FactoryGirl.create :article, max_age: 20}
#     let!(:article5) {FactoryGirl.create :article, min_quantity: 3}
#     let!(:article6) {FactoryGirl.create :article, max_quantity: 100}
#
#     it { expect(Article.by_article_type(:product).count).to eq(1) }
#     it { expect(Article.by_article_type(:product).first).to eq(article1) }
#
#     it { expect(Article.by_state(:draft).count).to eq(1) }
#     it { expect(Article.by_state(:draft).first).to eq(article2) }
#
#     it { expect(Article.by_user(article2.user).count).to eq(1) }
#     it { expect(Article.by_user(article2.user).first).to eq(article2) }
#
#     it { expect(Article.greater_than_min_age(11).count).to eq(1) }
#     it { expect(Article.greater_than_min_age(11).first).to eq(article3) }
#
#     it { expect(Article.less_than_max_age(11).count).to eq(1) }
#     it { expect(Article.less_than_max_age(11).first).to eq(article4) }
#
#     it { expect(Article.greater_than_min_quantity(11).count).to eq(1) }
#     it { expect(Article.greater_than_min_quantity(11).first).to eq(article5) }
#
#     it { expect(Article.less_than_max_quantity(11).count).to eq(1) }
#     it { expect(Article.less_than_max_quantity(11).first).to eq(article6) }
#   end
# end