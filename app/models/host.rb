class Host < ApplicationRecord
  PROPERTY_TYPES = [ 'Detached', 'Semi-detached' ].freeze
  HP_TYPES = [ 'Air source', 'Ground source' ].freeze

  acts_as_mappable auto_geocode: { field: :postcode }

  has_one :user

  validates :street_address, :city, :postcode, :property_type, :hp_type,
            presence: true
end
