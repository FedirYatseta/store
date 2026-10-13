module Api
  module V1
    module Admin
      class UsersController < BaseController
        before_action :set_user, only: %i[show update destroy]

        def index
          render json: User.order(:id)
        end

        def show
          render json: @user
        end

        def update
          if @user.update(user_params)
            render json: @user
          else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @user.destroy
          head :no_content
        end

        private

        def set_user
          @user = User.find(params[:id])
        end

        # Admin can change the role
        def user_params
          params.require(:user).permit(:first_name, :last_name, :email, :role, :password)
        end
      end
    end
  end
end