module Api
  module V1
    class MessagesController < ApplicationController
      def create
        message = Message.new(message_params)

        if message.save
        ActionCable.server.broadcast("chat_room_#{message.room_id}", {
            id: message.id,
            content: message.content,
            user_id: message.user_id,
            user_nickname: message.user&.nickname,
            created_at: message.created_at.strftime("%H:%M")
        })

        render json: {
            success: true,
            message: "Message sent successfully",
            data: {
            id: message.id,
            content: message.content,
            user_id: message.user_id,
            user_nickname: message.user&.nickname,
            created_at: message.created_at.strftime("%H:%M")
            }
        }, status: :created
        else
        render json: {
            success: false,
            error: message.errors.full_messages
        }, status: :unprocessable_entity
        end
      end

      private

      def message_params
        params.require(:message).permit(:room_id, :user_id, :content)
      end
    end
  end
end
