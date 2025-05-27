# app/channels/chat_channel.rb
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_room_#{params[:room_id]}"
  end

  def receive(data)
    begin
      # Validasi data
      unless data["user_id"] && data["content"] && params[:room_id]
        return
      end

      # Validasi user dan room exists
      user = User.find_by(id: data["user_id"])
      room = Room.find_by(id: params[:room_id])
      
      return unless user && room

      message = Message.create!(
        room_id: params[:room_id],
        user_id: data["user_id"],
        content: data["content"]
      )

      broadcast_data = {
        id: message.id,
        content: message.content,
        user_id: message.user_id,
        user_nickname: user.nickname,
        created_at: message.created_at.strftime("%H:%M")
      }

      ActionCable.server.broadcast("chat_room_#{params[:room_id]}", broadcast_data)
      
    rescue ActiveRecord::RecordInvalid => e
      # Optional: handle silently or notify error monitoring
    rescue StandardError => e
      # Optional: handle silently or notify error monitoring
    end
  end

  def unsubscribed
    # Cleanup if needed when channel is unsubscribed
  end
end
