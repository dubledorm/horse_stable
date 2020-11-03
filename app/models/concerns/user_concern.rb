# encoding: UTF-8
module UserConcern
  extend ActiveSupport::Concern

  AVATAR_SIZE = { width: 100, height: 100 }.freeze

  def get_avatar
    self.avatar.variant(resize_to_limit: [AVATAR_SIZE[:width], AVATAR_SIZE[:height]])
  end

  def user_confirmed?
    !self.confirmed_at.nil?
  end

  def unconfirmed_days_still_available
    (((self.created_at + (User.allow_unconfirmed_access_for || 0)) - Time.now) / 1.day).to_i
  end

  def name
    self.email
  end

  def has_service?(provider_name)
    self.services.by_provider(provider_name).any?
  end

  def main_description
    user_parameter.try(:description)
  end
end
