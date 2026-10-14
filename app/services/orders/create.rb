module Orders
  # Creates an Order + OrderDescription in a single transaction.
  # The total is calculated on the server from current prices, not taken from the client.
  class Create
    class Error < StandardError; end

    def initialize(user:, lines:)
      @user  = user
      @lines = lines
    end

    def call
      raise Error, "Order is empty" if @lines.empty?

      Order.transaction do
        order = @user.orders.create!
        total = @lines.sum { |line| add_line(order, line) }
        order.update!(amount: total)
        order
      end
    end

    private

    # Returns the total for the line item
    def add_line(order, line)
      item = Item.find_by(id: line[:item_id]) or raise Error, "Item #{line[:item_id]} not found"
      description = order.order_descriptions.create!(item: item, quantity: quantity_for(line[:quantity]))
      item.price * description.quantity
    end

    def quantity_for(value)
      quantity = case value
      when Integer
        value
      when String
        Integer(value, 10)
      end

      raise Error, "Quantity must be a positive integer" unless quantity&.positive?

      quantity
    rescue ArgumentError
      raise Error, "Quantity must be a positive integer"
    end
  end
end
