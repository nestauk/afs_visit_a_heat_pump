class Host < ApplicationRecord
  PROPERTY_TYPES = [ 'Detached property', 'Semi-detached property', 'Terrace property', 'Bungalow', 'Flat/masionette', 'Other' ].freeze
  PROPERTY_AGES = [ 'Pre 1920', '1920 - 1944', '1945 - 1964', '1965 - 1982', '1983 - 2002', 'Post 2003' ].freeze
  HP_TYPES = [ 'Air source', 'Ground source', 'Other' ].freeze

  acts_as_mappable auto_geocode: { field: :postcode }

  has_one :user
  has_one_attached :profile_picture # TODO: dependent destroy

  has_rich_text :description

  has_many :events, dependent: :destroy
  has_many :followers, dependent: :destroy

  validates :street_address, :city, :postcode, :property_type, :hp_type,
            :profile_picture, :no_of_bedrooms, :hp_manufacturer,
            :hp_year_of_install, :property_age, presence: true

  validates :no_of_bedrooms, :hp_size, numericality: { greater_than: 0, allow_nil: true }

  validates :property_type, inclusion: { in: PROPERTY_TYPES }
  validates :property_age, inclusion: { in: PROPERTY_AGES }
  validates :hp_type, inclusion: { in: HP_TYPES }

  def self.ransackable_attributes(auth_object = nil)
    %w[ hp_type postcode property_type ]
  end

  def address
    "#{street_address}, #{city}, #{postcode}"
  end

  def display_name
    "#{property_type} in #{city}"
  end

  def subtitle
    "#{hp_type} heat pump in a #{property_age} property, hosted by #{user.first_name.titleize}."
  end
end
