class Category < ApplicationRecord
  has_many :foods
  has_many :chefs, through: :foods
  has_many :order_items, through: :foods
  has_many :orders, through: :order_items
  has_many :users, through: :orders
  has_many :ingredients, through: :foods
end
