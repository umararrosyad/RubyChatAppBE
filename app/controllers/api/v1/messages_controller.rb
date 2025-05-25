module Api
  module V1
    class MessagesController < ApplicationController
      def create
        begin
          message = Message.new(message_params.except(:user_nickname))

          if message.save
            ActionCable.server.broadcast("chat_room_#{message.room_id}", {
              id: message.id,
              content: message.content,
              user_id: message.user_id,
              user_nickname: message_params[:user_nickname],
              created_at: message.created_at.strftime("%H:%M")
            })

            render json: {
              success: true,
              message: "Message sent successfully",
              data: {
                id: message.id,
                content: message.content,
                user_id: message.user_id,
                user_nickname: message_params[:user_nickname],
                created_at: message.created_at.strftime("%H:%M")
              }
            }, status: :created
          else
            render json: {
              success: false,
              error: message.errors.full_messages
            }, status: :unprocessable_entity
          end

        rescue => e
          render json: {
            success: false,
            error: "Internal Server Error",
            detail: e.message,
            location: e.backtrace.first # Menampilkan file dan baris error pertama
          }, status: :internal_server_error
        end
      end

      private

      def message_params
        params.require(:message).permit(:room_id, :user_id, :content, :user_nickname)
      end
    end
  end
end
