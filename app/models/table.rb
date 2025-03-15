class Table < ApplicationRecord
  belongs_to :user, optional: true  # Ensure user_id is optional when creating a table
  validates :num_of_seats, presence: true
  has_many :reservations, dependent: :destroy
end
