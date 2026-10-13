module Api
  module V1
    module Admin
      class ItemsController < BaseController
        before_action :set_item, only: %i[show update destroy]

        def index
          render json: Item.search(params[:q]).order(:id)
        end

        def show
          render json: @item
        end

        def create
          item = Item.new(item_params)
          if item.save
            render json: item, status: :created
          else
            render_errors(item)
          end
        end

        def update
          @item.update(item_params) ? render(json: @item) : render_errors(@item)
        end

        def destroy
          @item.destroy ? head(:no_content) : render_errors(@item)
        end

        private

        def set_item
          @item = Item.find(params[:id])
        end

        def item_params
          params.require(:item).permit(:name, :description, :price)
        end

        def render_errors(record)
          render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end