module Api
  module V1
    class ItemsController < BaseController
      # GET /api/v1/items?q=phone
      def index
        render json: Item.search(params[:q]).order(:name)
      end

      def show
        render json: Item.find(params[:id])
      end
    end
  end
end