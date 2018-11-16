# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :email, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true

  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  after_initialize :ensure_session_token

  #stores new user's password as a password_digest in table
  #(BCRYPT!! create)
  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @password = password #why is this line necessary?
  end

  #checks users' password when she logs in (BCRYPT!! new)
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  #find user by email
  #check if the password user provided is the correct password
  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  #called in reset_session_token! and ensure_session_token to keep code DRY
  def self.generate_session_token
    RandomSecure.urlsafe_base64(16)
  end

  #gives user a new session token(used when logging in)
  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  #ensures user has a session token (will assign one if user does not have one already)
  #this method is necessary for a new user or an existing user who has logged out
  #this check must happen for anyone trying to log in so we can track they are logged in
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

end
