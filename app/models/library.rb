class Library
  # Search a directory and return all of the files in it, recursively.
  #
  # Returns an Array of String file paths.


  #deze checkt dus de resultaten
  def self.fs_songs
    `find "#{Setup.first.path}" -type f -name '*.mp3' || '*.aac' || '*.flac'`.split("\n")
  end

  # Imports an array of songs into the database.
  #
  # Returns nothing.
  def self.import_songs
    dir = Dir.mktmpdir
    begin
      fs_songs.each do |path|
        import_song(path, dir)
      end
    ensure
      FileUtils.remove_entry_secure dir
    end
  end

  #dit ding importeerd dat had ik geleend enzo van die gem
  def self.import_song(path, dir)
    song = Song.where(:path => path).first

    if !song
      artist_name, title, album_name = fs_get_artist_and_title_and_album(path)
      artist = Artist.find_or_create_by_name(artist_name)
      genre = get_genre(path)
      genre = Genre.find_or_create_by_title(genre.present? ? genre.downcase : "unknown")

      album = Album.where(:artist_id => artist.id, :name => album_name).first
      if album.blank?
        image = get_tag2_image(path, album_name, dir)
        album = Album.create(:artist_id => artist.id, :name => album_name, :genre => genre, :art => File.new(image))
      end

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

  def self.get_tag2_image(path, album_name, dir)
    album_name = album_name.gsub("/", "-")
    Mp3Info.open(path) do |mp3|
      if mp3.tag2["APIC"]
        text_encoding, mime_type, picture_type, description, picture_data = mp3.tag2["APIC"].unpack("c Z* c Z* a*")
        album_art = File.new("#{dir}/#{album_name}.#{mime_type.split('/').last}", "w")
        album_art.write(picture_data)
        album_art.close
        return album_art.path
      else
        image_path = "#{Rails.root}/public/images/album.png"
      end
    end
    rescue Mp3Info::Mp3InfoError
  end

  def self.get_genre(path)
    Mp3Info.open(path) do |mp3|
      if mp3.tag2["TCON"]
        mp3.tag2["TCON"]
      else
        "No genre"
      end
    end
    rescue Mp3Info::Mp3InfoError
  end

end