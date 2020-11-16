class User < ApplicationRecord
  include UserConcern
  include TaggableConcern
  include GradeConcern
  include CategoryConcern

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :omniauthable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, omniauth_providers: [:github, :facebook, :vkontakte]

  has_many :services, dependent: :destroy
  has_many :galleries, dependent: :destroy
  has_many :pictures, through: :galleries
  has_many :articles, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_one :user_parameter, dependent: :destroy

  has_many :test_tasks


  has_one_attached :avatar
  has_one_attached :main_image

  validates :avatar, content_type: IMAGE_CONTENT_TYPES
  validates :main_image, content_type: IMAGE_CONTENT_TYPES
end
