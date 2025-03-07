class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :order_items, through: :orders
  has_many :foods, through: :order_items
  has_many :completed_orders, dependent: :destroy
  has_many :tables, dependent: :destroy
  has_many :reservations, dependent: :destroy
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, uniqueness: true, length: { is: 11 }
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where([ "lower(email) = :value OR phone_number = :value", { value: login.downcase } ]).first
    else
      where(conditions.to_h).first
    end
  end
end
