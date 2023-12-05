class Event < ApplicationRecord
  scope :active, -> { where('cancelled_at IS NULL AND date >= ?', Date.today).order(:date) }
  scope :past, -> { where('cancelled_at IS NULL AND date < ?', Date.today).order(:date) }
  scope :cancelled, -> { where('cancelled_at IS NOT NULL').order(:date) }

  belongs_to :host

  has_many :bookings, dependent: :destroy

  validates :date, :start_at, :end_at, :capacity, presence: true

  # TODO: capacity limit of 100 bookings?
  # TODO: date must be in the future
  # TODO: start_at cannot be after end_at
  # TODO: counter cache bookings.quantity sum
  # TODO: can't change capacity to less than bookings

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
end
