User.find_or_create_by!(email: "admin@example.com") do |u|
  u.first_name = "Admin"
  u.last_name  = "Admin"
  u.password   = "password123"
  u.role       = "admin"
end

[["Laptop", "15 inch laptop", 999.99], ["Phone", "Smartphone", 499.50], ["Headphones", "Wireless", 79.00]].each do |name, desc, price|
  Item.find_or_create_by!(name: name) { |i| i.description = desc; i.price = price }
end