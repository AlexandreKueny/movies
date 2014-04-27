class TFilm < ActiveRecord::Base

  belongs_to :torrent
  belongs_to :c_torrent, -> { where('deleted_at IS null') }, class_name: 'Torrent', foreign_key: 'torrent_id'
  has_many :films, through: :torrent

  scope :current, -> { includes(:torrent).where('torrents.deleted_at IS null').references(:torrents) }
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
    FROM t_films t
    INNER JOIN (SELECT
    size, COUNT(*) AS CountOf
    FROM t_films
    GROUP BY size
    HAVING COUNT(*)>1
    ) dt ON t.size=dt.size')
  end

end
