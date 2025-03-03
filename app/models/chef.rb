class Chef < ApplicationRecord
  has_many :order_items
  has_many :foods, through: :order_items
  has_many :orders, through: :order_items
  belongs_to :category
  has_one_attached :profile_image

  validate :acceptable_image

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
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

  private
  def acceptable_image
    unless profile_image.byte_size <= 1.megabyte
      errors.add(:profile_image, "is too big. Max size is 1MB.")
    end
    acceptable_types = [ "image/jpeg", "image/png", "image/jpg" ]
    unless acceptable_types.include?(profile_image.content_type)
      errors.add(:profile_image, "must be a JPEG, PNG, or JPG.")
    end
  end

end
