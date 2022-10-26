# frozen_string_literal: true
# encoding: UTF-8

module UserGroupConcern
  extend ActiveSupport::Concern

  # Концерн предоставляет возможность работать с группами объекта

  def add_user_group(user_group_id)
    user_group = UserGroup.find(user_group_id)
    raise StandardError, "Not found user_group with id #{user_group_id}" if user_group.nil?

    user_groups << user_group
  end

  def delete_user_group(user_group_id)
    user_group = UserGroup.find(user_group_id)
    raise StandardError, "Not found user_group with id #{user_group_id}" if user_group.nil?

    user_groups.delete(user_group)
  end

  def has_user_group?(user_group_id)
    !user_groups.find(user_group_id).nil?
  end

  def clear_user_groups
    user_groups.each do |user_group|
      delete_user_group(user_group)
    end
  end
end
