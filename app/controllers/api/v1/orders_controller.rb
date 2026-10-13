module Api
  module V1
    class OrdersController < BaseController
      def index
        orders = current_user.orders.order(created_at: :desc)
        render json: orders
      end

      # Розгорнутий заказ: позиції + товари
      def show
        order = current_user.orders.find(params[:id])
        render json: order_with_lines(order)
      end

      # POST /api/v1/orders
      # { "items": [ { "item_id": 1, "quantity": 2 }, ... ] }
      def create
        order = Orders::Create.new(user: current_user, lines: lines_params).call
        render json: order_with_lines(order), status: :created
      rescue Orders::Create::Error, ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def lines_params
        params.require(:items).map { |l| l.permit(:item_id, :quantity).to_h.symbolize_keys }
      end

      def order_with_lines(order)
        order.as_json(include: { order_descriptions: { only: %i[id quantity], include: { item: { only: %i[id name price] } } } })
      end
    end
  end
end