# frozen_string_literal: true

# Класс, объединяющий пользователей в группы
# Нужен для совместного использования тестов
class UserGroup < ApplicationRecord
  include HumanAttributeValue

  validates :name, :user_id, presence: true

  belongs_to :user
  belongs_to :project
  has_many :user_to_user_groups
  has_many :members, class_name: 'User', through: :user_to_user_groups, source: :user
  accepts_nested_attributes_for :user_to_user_groups, allow_destroy: true

  has_many :experiment_to_user_groups
  has_many :experiments, through: :experiment_to_user_groups
  accepts_nested_attributes_for :experiment_to_user_groups, allow_destroy: true

  def user_manager?(user)
    user_to_user_groups.where(user_id: user.id, access_right: 'manager').any?
  end
end
