class Food < ApplicationRecord
  belongs_to :category , optional: true, dependent:  :destroy
  has_many :ingredients, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_many :chefs, through: :order_items

  def category_name
    category.title
  end
end
