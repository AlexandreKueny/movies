class Film < ActiveRecord::Base

  belongs_to :torrent
  scope :deleted, -> { where('deleted_at IS not null') }
  scope :current, -> { where('deleted_at IS null') }
  scope :unique, -> { where(duplicate: false) }
  scope :duplicate, -> { where(duplicate: true) }

  def self.mark_duplicates
    self.find_duplicates.each do |entry|
      entry.duplicate = true
      entry.save
    end
  end

  def self.find_duplicates
    self.find_by_sql('SELECT
    t.id,t.name
    FROM films t
    INNER JOIN (SELECT
    size, COUNT(*) AS CountOf
    FROM films
    WHERE deleted_at ISNULL
    GROUP BY size
    HAVING COUNT(*)>1
    ) dt ON t.size=dt.size')
  end

  def self.assign_torrents
    self.assign_simple_torrent
    self.assign_complex_torrent
  end

  def self.assign_simple_torrent
    Film.current.unique.each do |film|
        film.assign_torrent(film.find_torrent)
    end
  end

  def find_torrent
    _t_film = TFilm.unique.where(size: self.size).first
    _t_film.c_torrent if _t_film
  end

  def assign_torrent(torrent)
    self.torrent = torrent
    self.save
  end

  def self.assign_complex_torrent
    f = self.current.duplicate.load
    tf = TFilm.includes(:torrent).duplicate.load
    f.each do |film|
      tf_found = film.find_torrent_by_name tf
      film.assign_torrent( tf_found.torrent) if tf_found
    end
  end

  def find_torrent_by_name(tfilms)
    tfilms.each do |tf|
      return tf if tf.name.chomp(File.extname(tf.name)).downcase == self.name.downcase
    end
    nil
  end
end
