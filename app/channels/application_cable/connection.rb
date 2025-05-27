
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      # no-op
    end

    def disconnect
      # no-op
    end

    private

    # Uncomment this if you need user authentication later
    # identified_by :current_user
    # 
    # def find_verified_user
    #   if verified_user = User.find_by(id: cookies.encrypted[:user_id])
    #     verified_user
    #   else
    #     reject_unauthorized_connection
    #   end
    # end
  end
end