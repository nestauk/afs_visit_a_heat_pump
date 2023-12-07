class Booking < ApplicationRecord
  generates_token_for :cancellation do
    cancelled_at
  end

  belongs_to :event

  validates :first_name, :last_name, :email, :quantity, presence: true

  validates :quantity, numericality: { greater_than: 0, less_than: 5 }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validate :already_booked, on: :create
  validate :no_places_left

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
        errors.add(:email, "already booked with #{email} - we've resent the booking confirmation email")
        VisitorMailer.booking_confirmation(event, self).deliver_now
      end
    end

    def no_places_left
      return if quantity.nil?

      errors.add(:quantity, 'no places left, try reducing the number of visitors') if event.active_bookings_count + quantity > event.capacity
    end
end
