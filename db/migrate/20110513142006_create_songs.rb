class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string  :title
      t.string  :path
      t.integer :artist_id
      t.integer :album_id
      t.integer :genre_id
      t.integer :playcount
      t.boolean :queued, :default => false
      t.boolean :now_playing, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
