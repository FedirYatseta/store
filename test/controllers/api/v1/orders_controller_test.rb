require "test_helper"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "returns a JSON error when items are missing" do
    sign_in users(:one)

    post api_v1_orders_url, as: :json

    assert_response :bad_request
    assert_equal "application/json", response.media_type
    assert JSON.parse(response.body).key?("error")
  end

  test "returns a JSON error when items are not an array" do
    sign_in users(:one)

    post api_v1_orders_url, params: { items: "invalid" }, as: :json

    assert_response :bad_request
    assert_equal "items must be an array", JSON.parse(response.body).fetch("error")
  end
end
