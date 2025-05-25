module Api
    module V1
        class RoomUsersController < ApplicationController
            # aksi-aksi controller di sini
        class RoomUsersController < ApplicationController
            def create
            room = Room.find(params[:room_id])
            user_ids = params[:user_ids] # array of UUID
        
            user_ids.each do |uid|
                RoomUser.find_or_create_by!(room_id: room.id, user_id: uid) do |ru|
                ru.joined_at = Time.current
                end
            end
        
            render json: { message: "Users joined" }, status: :ok
            end
        end
    end
  end
end