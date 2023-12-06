class Event < ApplicationRecord
  scope :active, -> { where('cancelled_at IS NULL AND date >= ?', Date.today).order(:date) }
  scope :past, -> { where('cancelled_at IS NULL AND date < ?', Date.today).order(:date) }
  scope :cancelled, -> { where('cancelled_at IS NOT NULL').order(:date) }

  belongs_to :host

  has_many :bookings, dependent: :destroy

  validates :date, :start_at, :end_at, :capacity, presence: true

  validates :capacity, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  validate :date_in_future, :end_time_after_start_time, :capacity_greater_than_bookings

  # TODO: counter cache bookings.quantity sum

  def cancelled_at=(value)
    bool = ActiveModel::Type::Boolean.new.cast(value)
    self[:cancelled_at] = bool.is_a?(TrueClass) ? Time.zone.now : nil
  end

  def cancel!
    update(cancelled_at: Time.now)
    bookings.each do |booking|
      HostMailer.cancel_event(self, booking).deliver_now
    end
  end

  def notify_changes!
    if (previous_changes.keys & ['date', 'start_at', 'end_at', 'capacity']).any?
      bookings.each do |booking|
        HostMailer.updated_event(self, booking).deliver_now
      end
    end
  end

  private

    def date_in_future
      if date.present?
        errors.add(:date, 'cannot be in the past') if date < Date.today
      end
    end

    def end_time_after_start_time
      if start_at.present? && end_at.present?
        errors.add(:end_at, 'end time must be after start time') if end_at <= start_at
      end
    end

    def capacity_greater_than_bookings
      places_booked = bookings&.sum(:quantity)
      if capacity.present? && places_booked
        errors.add(:capacity, "#{places_booked} places already booked, event capacity must be #{places_booked} or more") if capacity < places_booked
      end
    end
end
