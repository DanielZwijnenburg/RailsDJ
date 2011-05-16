class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :songs, :title
    add_index :artists, :name
    add_index :albums, :name
  end

  def self.down
    remove_index :songs, :title
    remove_index :artists, :name
    remove_index :albums, :name
  end
end
