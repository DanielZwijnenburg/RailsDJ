class CreateSetups < ActiveRecord::Migration
  def self.up
    create_table :setups do |t|
      t.string :path
      t.boolean :setup_completed, :default => false
      t.timestamps
    end
    Setup.create!
  end

  def self.down
    drop_table :setups
  end
end
