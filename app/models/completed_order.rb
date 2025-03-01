class CompletedOrder < ApplicationRecord
  belongs_to :order
  belongs_to :user

  def user_name
    user&.first_name
  end
end
