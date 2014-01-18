class AddTorrentIdToFilm < ActiveRecord::Migration
  def change
    add_reference :films, :torrent, index: true
  end
end
