module Api
  module V1
    module Admin
      class BaseController < Api::V1::BaseController
        before_action :require_admin!

        private

        def require_admin!
          head :forbidden unless current_user.admin?
        end
      end
    end
  end
end