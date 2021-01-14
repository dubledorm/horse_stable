class Blog < ApplicationRecord
  include TaggableConcern
  include HumanAttributeValue

  BLOG_TYPES = %w(event article news_article).freeze
  BLOG_STATES = %w(active deleted draft).freeze

  belongs_to :user
  belongs_to :gallery, optional: true # Может быть добавлнена галерея с картинками

  has_one_attached :main_image # Может иметь одну основную картинку

  validates :post_type, :state, :title, presence: true
  validates :post_type, inclusion: { in: BLOG_TYPES }
  validates :state, inclusion: { in: BLOG_STATES }
  #
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  #
  # mappings do
  #   indexes :title,  type: 'text', analyzer: 'russian'
  #   indexes :content, type: 'text', analyzer: 'russian'
  # end
  #
  # def self.search(query)
  #   __elasticsearch__.search(
  #       {
  #           query: {
  #               multi_match: {
  #                   query: query,
  #                   fields: ['title', 'content']
  #               }
  #           }
  #       }
  #   )
  # end
end
