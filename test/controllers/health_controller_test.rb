require "test_helper"

class HealthControllerTest < ActionDispatch::IntegrationTest
  test "returns success for the health check endpoint" do
    get rails_health_check_url

    assert_response :ok
  end
end
