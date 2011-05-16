class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :song_id
      t.integer :user_id
      t.integer :artist_id
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
