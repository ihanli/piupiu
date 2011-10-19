class AddDeletedToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :deleted, :boolean, :default => 0
  end

  def self.down
    remove_column :posts, :deleted
  end
end
