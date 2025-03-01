class Category < ApplicationRecord
  has_many :foods , dependent: :destroy
  has_many :chefs, through: :foods
  has_many :order_items, through: :foods
  has_many :orders, through: :order_items
  has_many :users, through: :orders
  has_many :ingredients, through: :foods
  has_one_attached :image , dependent: :destroy


  validate :acceptable_image


  private
  def acceptable_image
    unless image.byte_size <= 1.megabyte
      errors.add(:image, "is too big. Max size is 1MB.")
    end
    acceptable_types = [ "image/jpeg", "image/png", "image/jpg" ]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG, PNG, or JPG.")
    end
  end
end
