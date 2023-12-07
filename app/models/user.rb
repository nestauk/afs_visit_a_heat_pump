class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :host, optional: true

  validates :email, :first_name, :last_name, :accepted_terms_at, presence: true

  validate :password_format

  def accepted_terms_at=(value)
    bool = ActiveModel::Type::Boolean.new.cast(value)
    self[:accepted_terms_at] = bool.is_a?(TrueClass) ? Time.zone.now : nil
  end

  private

    def password_format
      return if password.nil? || password.empty?

      unless password =~ /[A-Z]/ && password =~ /[a-z]/ && password =~ /[0-9]/
        errors.add(:password, 'must contain at least one uppercase letter, one lowercase letter, and one number')
      end
    end
end
