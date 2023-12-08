class Event < ApplicationRecord
  scope :active, -> { where('cancelled_at IS NULL AND date >= ?', Date.today).order(:date) }
  scope :past, -> { where('cancelled_at IS NULL AND date < ?', Date.today).order(:date) }
  scope :cancelled, -> { where('cancelled_at IS NOT NULL').order(:date) }
  scope :in_3_days, -> { active.where(date: Date.today + 3) }

  belongs_to :host

  has_many :bookings, dependent: :destroy

  validates :date, :start_at, :end_at, :capacity, presence: true

  validates :capacity, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  validate :date_in_future, :end_time_after_start_time, :capacity_greater_than_bookings

  # TODO: counter cache bookings.quantity sum

  def active_bookings_count
    bookings.where('cancelled_at IS NULL').sum(:quantity)
  end

  def capacity_reached?
    active_bookings_count == capacity
  end

  def cancel!
    update(cancelled_at: Time.now)
    bookings.each do |booking|
      VisitorMailer.event_cancelled(self, booking).deliver_now
    end
  end

  def notify_changes!
    if (previous_changes.keys & ['date', 'start_at', 'end_at', 'capacity']).any?
      bookings.each do |booking|
        VisitorMailer.event_updated(self, booking).deliver_now
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
      if capacity.present?
        errors.add(
          :capacity,
          "#{active_bookings_count} places already booked, event capacity must be #{active_bookings_count} or more"
        ) if capacity < active_bookings_count
      end
    end
end
