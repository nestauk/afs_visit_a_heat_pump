class Host < ApplicationRecord
  acts_as_mappable auto_geocode: { field: :postcode }

  has_one :user

  validates :street_address, :city, :postcode, :property_type, presence: true
end
