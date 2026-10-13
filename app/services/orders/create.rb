module Orders
  # Створює Order + OrderDescription в одній транзакції.
  # Сума рахується на сервері з актуальних цін, а не береться з клієнта.
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

    # Повертає суму по позиції
    def add_line(order, line)
      item = Item.find_by(id: line[:item_id]) or raise Error, "Item #{line[:item_id]} not found"
      description = order.order_descriptions.create!(item: item, quantity: line[:quantity])
      item.price * description.quantity
    end
  end
end