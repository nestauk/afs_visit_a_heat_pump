class Follower < ApplicationRecord
  belongs_to :host

  validates :email, presence: true

  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: 'please provide a valid email address'
  }

  validate :already_following, on: :create

  private

    def already_following
      errors.add(:email, 'already following host') if Follower.find_by(host: host, email: email)
    end
end