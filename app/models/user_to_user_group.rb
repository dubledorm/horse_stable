# frozen_string_literal: true

# Связка пользователей с группой. Также, содержит права пользователя
class UserToUserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :user_group
end
