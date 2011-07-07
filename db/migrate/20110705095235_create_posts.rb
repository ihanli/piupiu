class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.references :user
      t.string "image_file_name"
      t.string "image_content_type"
      t.integer "image_file_size"
      t.datetime "image_updated_at"
      t.string "ancestry"
    
      t.timestamps
    end
    
    add_index :posts, :ancestry
  end

  def self.down
    drop_table :posts
    remove_index :posts, :ancestry
  end
end
