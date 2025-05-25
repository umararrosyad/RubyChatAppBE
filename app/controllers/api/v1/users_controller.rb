module Api
  module V1
    class UsersController < ApplicationController
      def index
        if params[:q].present?
            users = User.where("nickname ILIKE ?", "%#{params[:q]}%")
        else
            users = User.all
        end

        render json: users
      end

      def create
        user = User.new(nickname: params[:nickname])

        if user.save
            render json: user
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:nickname)
      end
    end
  end
end
