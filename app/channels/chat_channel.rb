# app/channels/chat_channel.rb
class ChatChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "User subscribed to chat_room_#{params[:room_id]}"
    stream_from "chat_room_#{params[:room_id]}"
  end

  def receive(data)
    Rails.logger.info "Received data: #{data.inspect}"
    
    begin
      # Validasi data
      unless data["user_id"] && data["content"] && params[:room_id]
        Rails.logger.error "Missing required data: #{data.inspect}"
        return
      end

      # Validasi user dan room exists
      user = User.find_by(id: data["user_id"])
      room = Room.find_by(id: params[:room_id])
      
      unless user && room
        Rails.logger.error "User or Room not found. User: #{user}, Room: #{room}"
        return
      end

      message = Message.create!(
        room_id: params[:room_id],
        user_id: data["user_id"],
        content: data["content"]
      )

      Rails.logger.info "Message created: #{message.id}"

      broadcast_data = {
        id: message.id,
        content: message.content,
        user_id: message.user_id,
        user_nickname: user.nickname,
        created_at: message.created_at.strftime("%H:%M")
      }

      ActionCable.server.broadcast("chat_room_#{params[:room_id]}", broadcast_data)
      Rails.logger.info "Message broadcasted: #{broadcast_data}"
      
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to create message: #{e.message}"
    rescue StandardError => e
      Rails.logger.error "Error in ChatChannel#receive: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  def unsubscribed
    Rails.logger.info "User unsubscribed from chat_room_#{params[:room_id]}"
  end
end