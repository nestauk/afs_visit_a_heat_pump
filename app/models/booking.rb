class Booking < ApplicationRecord
  belongs_to :event

  validates :first_name, :last_name, :email, :quantity, presence: true

  validates :quantity, numericality: { greater_than: 0, less_than: 5 }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validate :already_booked

  def full_name
    "#{first_name} #{last_name}"
  end

  def notify_host!
    HostMailer.new_booking(event, self).deliver_now
  end

  def notify_visitor!
    VisitorMailer.booking_confirmation(event, self).deliver_now
  end

  private

  def already_booked
    if Booking.where(event: event, email: email).any?
      # TODO: resend booking confirmation?
        errors.add(:email, "already booked with #{email}")
      end
    end
end
