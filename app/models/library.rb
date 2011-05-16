class Library
  # Search a directory and return all of the files in it, recursively.
  #
  # Returns an Array of String file paths.


  #deze checkt dus de resultaten
  def self.fs_songs
    `find "#{Setup.first.path}" -type f ! -name '.*'`.split("\n")
  end

  # Imports an array of songs into the database.
  #
  # Returns nothing.
  def self.import_songs
    fs_songs.each do |path|
      import_song(path)
    end
  end

  #dit ding importeerd dat had ik geleend enzo van die gem
  def self.import_song(path)
    artist_name,title,album_name = fs_get_artist_and_title_and_album(path)
    got_genre = get_genre(path)
    image = get_tag2_image(path, album_name)
    artist = Artist.find_or_create_by_name(artist_name)
    song = Song.where(:path => path).first
    genre = Genre.find_or_create_by_title(got_genre.downcase)
    if !song
      album = Album.where(:artist_id => artist.id, :name => album_name).first ||
              Album.create(:artist_id => artist.id, :name => album_name, :genre => genre, :art => File.new(image))
      Song.create(:path => path,
                  :artist => artist,
                  :album => album,
                  :title => title,
                  :genre => genre)
    end
  end

  def self.fs_get_artist_and_title_and_album(path)
    AudioInfo.open(path) do |info|
      return info.artist.try(:strip),
             info.title.try(:strip),
             info.album.try(:strip)
    end
  rescue AudioInfoError
  end


  def self.get_tag2_image(path, alb_name)
    FileUtils.mkdir_p("#{RAILS_ROOT}/public/images/albumart/")
    file_path = RAILS_ROOT + "/public/images/albumart/"
    if alb_name.present?
      album_name = alb_name.gsub("/","-")
    else
      album_name = "geen album"
    end
    unless FileTest.exists?(file_path + album_name + ".*")
      Mp3Info.open(path) do |mp3|
        if mp3.tag2["APIC"]
          text_encoding, mime_type, picture_type, description, picture_data = mp3.tag2["APIC"].unpack("c Z* c Z* a*")
          album_art = File.new("#{RAILS_ROOT}/public/images/albumart/#{album_name}.#{mime_type.split('/').last}","w")
          album_art.write(picture_data)
          album_art.close
          return album_art.path
        else
          image_path = RAILS_ROOT + "/public/images/album.png"
        end
      end
    else
      "false"
    end
  end

  def self.get_genre(path)
    Mp3Info.open(path) do |mp3|
      if mp3.tag2["TCON"]
        mp3.tag2["TCON"]
      else
        "No genre"
      end
    end
  end

end