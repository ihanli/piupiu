class Post < ActiveRecord::Base
  has_ancestry
  has_attached_file :image, :default_style => :medium, :styles => { :medium => "200x200"}
  validates_presence_of :user
  validates_attachment_presence :image
  
  belongs_to :user
  
  attr_accessible :image, :user
end