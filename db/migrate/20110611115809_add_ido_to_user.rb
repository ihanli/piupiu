class AddIdoToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :ido, :string
  end

  def self.down
    remove_column :users, :ido
  end
end
