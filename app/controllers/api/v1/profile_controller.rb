module Api
  module V1
    class ProfileController < BaseController
      def show
        render json: current_user
      end

      def update
        if current_user.update(profile_params)
          render json: current_user
        else
          render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # role навмисно не дозволена
      def profile_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end
  end
end