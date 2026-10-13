class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { user: resource }, status: :ok
  end

  def respond_to_on_destroy(*args)
    render json: { message: "Logged out" }, status: :ok
  end
end