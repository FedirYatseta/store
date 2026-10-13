class User < ApplicationRecord
  ROLES = %w[user admin].freeze

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :orders, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :role, inclusion: { in: ROLES }

  def admin?
    role == "admin"
  end

  def as_json(*)
    super(only: %i[id first_name last_name email role])
  end
end