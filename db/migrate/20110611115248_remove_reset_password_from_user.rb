class RemoveResetPasswordFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
  end

  def self.down
    add_column :users, :reset_password_sent_at, :timestamp
    add_column :users, :reset_password_token, :string
  end
end
