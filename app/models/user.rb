class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :confirmable, :timeoutable
  has_attached_file :avatar, :default_style => :thumb, :styles => { :thumb => "203x147", :icon => "64x48" }, :url => "/system/:id/:attachment/:style/:filename"
  before_validation :decode_image_data, :if => :image_data_provided?

  has_many :posts, :dependent => :destroy
  validates_attachment_presence :avatar, { :message => "has to be drawn" }
  validates_attachment_size :avatar, :less_than => 5.megabytes

  attr_accessor :image_data
  attr_accessible :email, :password, :password_confirmation, :reset_password_token, :country, :ido, :avatar, :image_data

  private

  def image_data_provided?
    !self.image_data.blank?
  end

  def decode_image_data
    data = StringIO.new(Base64.decode64(image_data))
    data.class.class_eval { attr_accessor :original_filename, :content_type }
    data.original_filename = "avatar.jpg"
    data.content_type = "image/jpg"
    self.avatar = data
  end
end
