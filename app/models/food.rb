class Food < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :category, optional: true
  has_many :ingredients, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_many :chefs, through: :order_items
  has_one_attached :image, dependent: :destroy

  validate :acceptable_image

  def acceptable_image
    unless image.byte_size <= 3.megabyte
      errors.add(:image, "is too big. Max size is 3MB.")
    end
    acceptable_types = [ "image/jpeg", "image/png", "image/jpg" ]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG, PNG, or JPG.")
    end
  end

  def category_name
    category.title
  end



  settings index: { number_of_shards: 1, number_of_replicas: 0 } do
    settings analysis: {
      normalizer: {
        lowercase_normalizer: {
          type: "custom",
          filter: [ "lowercase" ]
        }
      }
    }

    mappings dynamic: "false" do
      indexes :name, type: "keyword", copy_to: "all_fields", fields: {
        lower: { type: "keyword", normalizer: "lowercase_normalizer" }
      }
      indexes :search_all, type: "text", analyzer: "standard"
    end
  end
end
