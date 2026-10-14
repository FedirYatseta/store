require "test_helper"

class Orders::CreateTest < ActiveSupport::TestCase
  test "calculates the amount from current item prices" do
    order = Orders::Create.new(
      user: users(:one),
      lines: [ { item_id: items(:one).id, quantity: 2, price: 0 } ]
    ).call

    assert_equal BigDecimal("19.98"), order.amount
    assert_equal 2, order.order_descriptions.sole.quantity
  end

  test "rejects invalid quantities without creating an order" do
    [ nil, 0, -1, 1.5, "1.5", "invalid" ].each do |quantity|
      assert_no_difference [ "Order.count", "OrderDescription.count" ] do
        error = assert_raises(Orders::Create::Error) do
          Orders::Create.new(
            user: users(:one),
            lines: [ { item_id: items(:one).id, quantity: quantity } ]
          ).call
        end

        assert_equal "Quantity must be a positive integer", error.message
      end
    end
  end

  test "rolls back the order when an item does not exist" do
    assert_no_difference [ "Order.count", "OrderDescription.count" ] do
      assert_raises(Orders::Create::Error) do
        Orders::Create.new(
          user: users(:one),
          lines: [ { item_id: -1, quantity: 1 } ]
        ).call
      end
    end
  end
end
