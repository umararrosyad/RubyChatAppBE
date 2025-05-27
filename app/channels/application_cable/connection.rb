
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      # Simply accept connection without logging for now
      # This should fix the logger error
    end

    def disconnect
      # Connection closed
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