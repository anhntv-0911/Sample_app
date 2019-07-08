class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validate.validEmail
  attr_accessor :remember_token
  before_save { email.downcase! }

  validates :name, presence: true, length: { maximum: Settings.validate.maxName }
  validates :email, presence: true, length: { maximum: Settings.validate.maxEmail }, format: {with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: Settings.validate.minPass }

  has_secure_password

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest( remember_token )
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
