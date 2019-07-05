class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: Settings.validate.maxName }
  VALID_EMAIL_REGEX = Settings.validate.validEmail
  validates :email, presence: true, length: { maximum: Settings.validate.maxEmail }, format: {with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: Settings.validate.minPass }

  has_secure_password
end
