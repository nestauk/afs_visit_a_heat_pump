class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :host, optional: true

  validates :email, :first_name, :last_name, :accepted_terms_at, presence: true

  def accepted_terms_at=(value)
    bool = ActiveModel::Type::Boolean.new.cast(value)
    self[:accepted_terms_at] = bool.is_a?(TrueClass) ? Time.zone.now : nil
  end
end
