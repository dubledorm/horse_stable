module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      Rails.logger.debug('!!!!!!!! cookies.encrypted[:user_id] = ' + cookies.encrypted['_portal_session']['warden.user.user.key'][0][0].to_s)
      if verified_user = User.find_by(id: cookies.encrypted['_portal_session']['warden.user.user.key'][0][0])
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
