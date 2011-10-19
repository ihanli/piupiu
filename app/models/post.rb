class Post < ActiveRecord::Base
  has_ancestry
  has_attached_file :image, :default_style => :medium, :styles => { :medium => "200x200"}, :url => "/system/:user/:attachment/:id/:style/:normalized_image_file_name"
  validates_presence_of :user
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  belongs_to :user

  attr_accessible :image, :user, :ancestry

  def to_node
    geo = Paperclip::Geometry.from_file(image.to_file(:medium))

    {
      "id" => self.id,
      "url" => self.deleted? ? "/images/grabstein-19.png" : self.image.url(:medium),
      "creator_url" => self.creator.avatar.url(:icon),
      "width" => geo.width,
      "height" => geo.height,
      "comments"   => self.children.map { |c| c.to_node }
    }
  end

  def set_ancestor(ancestor)
    return false unless parent = Post.find_by_id(ancestor)
    self.ancestry = (parent.is_root? ? parent.id.to_s : "#{parent.ancestry}/#{parent.id}")
  end
  
  def self.sort_by_criteria(array, criteria, order)
    array.sort! do |a,b|
      if order == "DESC"
        if criteria == "created_at"
          b.created_at <=> a.created_at
        else
          b.descendants.count <=> a.descendants.count
        end
      else
        if criteria == "created_at"
          a.created_at <=> b.created_at
        else
          a.descendants.count <=> b.descendants.count
        end
      end
    end
  end
  
  def creator
    self.user
  end
  
  def last_contributor   
    if self.root.is_childless?
      self.root.user
    else
      descendants_list = self.root.descendants
      descendants_list.sort! { |a,b| b.created_at <=> a.created_at }
      descendants_list.first.user
    end
  end
  
  def deleted?
    self.deleted
  end
  
  def normalized_image_file_name
    "#{self.id}-#{self.image_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}" 
  end
  
  private
  
  Paperclip.interpolates :user  do |attachment, style|
    attachment.instance.user.id
  end
  
  Paperclip.interpolates :normalized_image_file_name do |attachment, style|
    attachment.instance.normalized_image_file_name
  end
end