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
    add_index :posts, :user_id
  end

  def self.down
    remove_index :posts, :ancestry
    remove_index :posts, :user_id
    drop_table :posts
  end
end
