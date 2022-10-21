# frozen_string_literal: true

# Класс, объединяющий пользователей в группы
# Нужен для совместного использования тестов
class UserGroup < ApplicationRecord
  include HumanAttributeValue

  validates :name, :user_id, presence: true

  belongs_to :user
  has_many :user_to_user_groups
  has_many :members, class_name: 'User', through: :user_to_user_groups, source: :user
  accepts_nested_attributes_for :user_to_user_groups, allow_destroy: true
end
