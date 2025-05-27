# app/channels/chat_channel.rb
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_room_#{params[:room_id]}"
  end

  def receive(data)
    message = Message.create!(
      room_id: params[:room_id],
      user_id: data["user_id"],
      content: data["content"]
    )

    ActionCable.server.broadcast("chat_room_#{params[:room_id]}", {
      id: message.id,
      content: message.content,
      user_id: message.user_id,
      user_nickname: message.user.nickname,
      created_at: message.created_at.strftime("%H:%M")
    })
  end
end