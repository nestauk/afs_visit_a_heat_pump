class Event < ApplicationRecord
  belongs_to :host

  validates :date, :start_at, :end_at, :capacity, presence: true

  # TODO: capacity limit of 100 bookings?
  # TODO: date must be in the future
  # TODO: start_at cannot be after end_at
end
