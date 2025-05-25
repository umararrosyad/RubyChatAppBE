module Api
  module V1
    class RoomsController < ApplicationController
      # Tangkap error record not found dan validasi gagal
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

      def index
        if params[:user_id].present?
            user = User.find(params[:user_id])
            rooms = user.rooms
        else
            rooms = Room.all
        end

        render json: rooms
      end

      def show
        room = Room.find(params[:id])
        render json: room
      end

      def create
        user_ids = params[:user_ids]

        # Validasi: pastikan ada minimal 2 user_id
        if user_ids.blank? || user_ids.size < 2
            return render json: { error: 'Minimal dua user harus bergabung ke room' }, status: :unprocessable_entity
        end

        # Buat room baru
        room = Room.create!(name: params[:name])

        # Tambahkan setiap user ke dalam RoomUser
        user_ids.each do |uid|
            RoomUser.create!(
            room: room,
            user_id: uid,
            joined_at: Time.current
            )
        end

        render json: room, status: :created
      end

      def join
        room = Room.find(params[:id])
        user_ids = params[:user_ids]

        if user_ids.blank? || !user_ids.is_a?(Array)
            render json: { error: "user_ids parameter is required and must be an array" }, status: :bad_request
            return
        end

        user_ids.each do |uid|
            RoomUser.find_or_create_by!(room_id: room.id, user_id: uid) do |ru|
            ru.joined_at = Time.current
            end
        end

        render json: { message: "Users joined room" }
      end

      def messages
        room_id = params[:id].to_s
        messages = Message.includes(:user).where(room_id: room_id).order(created_at: :asc)

        result = messages.map do |msg|
            {
                id: msg.id,
                content: msg.content,
                user_id: msg.user_id,
                user_nickname: msg.user.nickname,
                created_at: msg.created_at.strftime("%H:%M")
            }
        end

        render json: result
      end

      def users
        room = Room.find(params[:id])
        users = room.users
        render json: users
      end

      private

      def room_params
        params.require(:room).permit(:name)
      end

      # Method untuk menangani error jika data tidak ditemukan
      def record_not_found(error)
        render json: { error: error.message }, status: :not_found
      end

      # Method untuk menangani error jika validasi gagal
      def record_invalid(error)
        render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end