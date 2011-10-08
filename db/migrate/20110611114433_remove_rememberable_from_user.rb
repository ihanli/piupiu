class RemoveRememberableFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :remember_created_at
  end

  def self.down
    add_column :users, :remember_created_at, :timestamp
  end
end
