# encoding: utf-8
# frozen_string_literal: true

module UserCabinet
  class UserGroupsController < PrivateAreaController
    add_breadcrumb I18n.t('user_groups'), :user_cabinet_user_groups_path, only: [:show]

  end
end
