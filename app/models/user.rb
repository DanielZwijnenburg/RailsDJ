require 'bcrypt'
class User < ActiveRecord::Base
  has_many :votes

  attr_accessor :password

  validates_confirmation_of :password
  validates_presence_of     :password, :on => :create
  validates_presence_of     :name

  validates :email,   :presence => true,
            :length => {:minimum => 3, :maximum => 254},
            :uniqueness => true,
            :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates_attachment_presence :avatar
  has_attached_file :avatar, :styles => { :thumb => "70x70#", :medium => "150x150>" }

  before_save :encrypt_password

  scope :online, where(:online => true)

  def vote_for(song)
    votes.create(:song => song, :artist => song.artist)
  end

  def votes_count
    votes.count
  end

  def favorite_artists
    Artist.includes(:votes).
      where("votes.user_id = ?",id).
      group("votes.artist_id").
      order("count(votes.artist_id) desc").
      limit(5).
      all
  end

  def favorite_tunes
    Song.includes(:votes).
      where("votes.user_id = ?",id).
      group("votes.song_id").
      order("count(votes.song_id) desc").
      limit(5).
      all
  end

  # def online
  #   # raise self.inspect
  #   self.update_attributes :online => true
  # end
  #
  # def offline
  #   self.update_attributes :online => false
  # end

  def gravatar_id
    Digest::MD5.hexdigest(email)
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
