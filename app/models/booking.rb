class Booking < ApplicationRecord
  belongs_to :event

  validates :first_name, :last_name, :email, :quantity, presence: true

  # TODO: validate email
  # TODO: already booked

  def full_name
    "#{first_name} #{last_name}"
  end
end
