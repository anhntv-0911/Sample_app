class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.validate.validEmail

  scope :activated, -> {where activated: true}

  attr_accessor :remember_token, :activation_token
  before_save { email.downcase! }
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: Settings.validate.maxName }
  validates :email, presence: true, length: { maximum: Settings.validate.maxEmail }, format: {with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: Settings.validate.minPass }

  has_secure_password

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest( remember_token )
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update remember_digest: nil
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
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

  private
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
