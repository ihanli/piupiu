class Post < ActiveRecord::Base
  has_ancestry
  has_attached_file :image, :default_style => :medium, :styles => { :medium => "200x200"}
  validates_presence_of :user
  validates_attachment_presence :image
  
  belongs_to :user
  
  attr_accessible :image, :user, :ancestry
  
  def to_node
    geo = Paperclip::Geometry.from_file(image.to_file(:medium))
    
    { 
      "id" => self.id,
      "url" => self.image.url(:medium),
      "width" => geo.width,
      "height" => geo.height,
      "comments"   => self.children.map { |c| c.to_node }
    }
  end
end