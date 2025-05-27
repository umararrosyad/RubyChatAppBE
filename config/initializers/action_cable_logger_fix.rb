module ActionCable
  module Connection
    class TaggedLoggerProxy
      def log(type, message)
        logger_instance = @logger || Rails.logger
        return unless logger_instance
        logger_instance.public_send(type, message)
      end
    end
  end
end