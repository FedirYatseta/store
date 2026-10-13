class Item < ApplicationRecord
  has_many :order_descriptions, dependent: :restrict_with_error

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # Search by name and description
  scope :search, lambda { |query|
    next all if query.blank?

    pattern = "%#{sanitize_sql_like(query)}%"
    where("name ILIKE :q OR description ILIKE :q", q: pattern)
  }
end