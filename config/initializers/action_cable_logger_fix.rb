module ActionCable
  module Connection
    class TaggedLoggerProxy
      def log(type, message)
        return unless logger
        logger.public_send(type, message)
      end
    end
  end
end