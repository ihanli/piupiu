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

  def replace_image_with(filename)
    data = File.open(filename, "r")
    data.class.class_eval { attr_accessor :original_filename, :content_type }
    data.original_filename = "grabstein-19.png"
    data.content_type = "image/png"
    self.image = data
  end

  def set_ancestor(ancestor)
    return false unless parent = Post.find_by_id(ancestor)
    self.ancestry = (parent.is_root? ? parent.id.to_s : "#{parent.ancestry}/#{parent.id}")
  end
  
  def self.sort_by_criteria(array, criteria, order)
    array.sort! { |a,b| order == "DESC" ? b.send(criteria) <=> a.send(criteria) : a.send(criteria) <=> b.send(criteria) }
  end
end