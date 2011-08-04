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
    parent = Post.find_by_id(ancestor)

    return false unless parent

    if parent.is_root?
      self.ancestry = parent.id.to_s
    else
      self.ancestry = "#{parent.ancestry}/#{parent.id}"
    end

    return true
  end

  def self.sort_by_creation(array, order)
    if order == "DESC"
      array.sort! { |a,b| b.created_at <=> a.created_at }
    else order == "ASC"
      array.sort! { |a,b| a.created_at <=> b.created_at }
    end
  end

  def self.sort_by_node_count(array, order)
    if order == "DESC"
      array.sort! { |a,b| b.descendants.count <=> a.descendants.count }
    else order == "ASC"
      array.sort! { |a,b| a.descendants.count <=> b.descendants.count }
    end
  end
end