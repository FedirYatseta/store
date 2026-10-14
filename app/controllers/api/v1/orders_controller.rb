module Api
  module V1
    class OrdersController < BaseController
      def index
        orders = current_user.orders.order(created_at: :desc)
        render json: orders
      end

      # Expanded order: positions + products
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
      rescue ActionController::ParameterMissing, ActionController::BadRequest => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      def lines_params
        items = params.require(:items)
        raise ActionController::BadRequest, "items must be an array" unless items.is_a?(Array)

        items.map do |line|
          raise ActionController::BadRequest, "each item must be an object" unless line.is_a?(ActionController::Parameters)

          line.permit(:item_id, :quantity).to_h.symbolize_keys
        end
      end

      def order_with_lines(order)
        order.as_json(include: { order_descriptions: { only: %i[id quantity], include: { item: { only: %i[id name price] } } } })
      end
    end
  end
end
