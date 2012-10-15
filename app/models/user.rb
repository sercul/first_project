require 'digest'
class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_many :microposts
  validates :name, :email, :presence => true

  validates :password,
            :confirmation => true

  validates :password, :presence => true, :on => :create,
            :confirmation => true,
            :length => {:within => 6..40}

  before_save :encrypt_password


  def has_password?(submitted_password)

    self.password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    return nil if user.nil?
    return user if user.salt == cookie_salt
  end

  def check_hz(id)
    user = User.find_by_id(id)
    if user.nil?
      return nil
    else
      return user.password
    end
  end

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    if (password != '')
      self.password = encrypt(password)
    else
      self.password = check_hz(self.id)
    end

  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end


end
