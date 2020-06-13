class User < ApplicationRecord
  paginates_per 20
  include StringNormalizer
  has_many :wordnotes, class_name: "Wordnote", dependent: :destroy
  has_many :tango_datum, class_name: "TangoDatum", dependent: :destroy
  has_many :tango_config, class_name: "TangoConfig", dependent: :destroy
  mount_uploader :profile_image, ProfileImageUploader
  validate :profile_image_size
  

  before_validation do 
    self.name = normalize_as_name(name)
    self.email = normalize_as_email(email)
  end
  validates :name, presence: true
  validates :email, presence: true, "valid_email_2/email": true,
    uniqueness: true
  def password=(raw_password)
    if raw_password.kind_of?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end
  private def profile_image_size
    if profile_image.size > 1.megabytes
      errors.add(:profile_image, "should be less than 1MB")
    end
  end

end
