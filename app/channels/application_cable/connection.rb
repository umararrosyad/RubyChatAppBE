module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      # Log connection attempt (safe logging)
      Rails.logger&.add_tags "ActionCable", request.remote_ip
      
      # Accept all connections for now (remove this after testing)
      Rails.logger&.info "WebSocket connection established from #{request.remote_ip}"
      Rails.logger&.info "Origin: #{request.headers['Origin']}"
      Rails.logger&.info "Host: #{request.headers['Host']}"
    end

    def disconnect
      Rails.logger&.info "WebSocket connection closed"
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