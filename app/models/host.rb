class Host < ApplicationRecord
  PROPERTY_TYPES = [ 'Detached', 'Semi-detached', 'Terrace', 'Bungalow', 'Flat/masionette', 'Other' ].freeze
  HP_TYPES = [ 'Air source', 'Ground source', 'Other' ].freeze

  acts_as_mappable auto_geocode: { field: :postcode }

  has_one :user
  has_one_attached :profile_picture # TODO: dependent destroy

  has_many :events, dependent: :destroy

  validates :street_address, :city, :postcode, :property_type, :hp_type,
            :profile_picture, :no_of_bedrooms, :hp_manufacturer,
            :hp_year_of_install, presence: true

  validates :no_of_bedrooms, :hp_size, numericality: { greater_than: 0, allow_nil: true }

  def upcoming_events
    events.where('date > ?', Date.today)
  end
end
