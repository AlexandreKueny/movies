json.array!(@torrents) do |torrent|
  json.extract! torrent, :id, :name, :path, :comment, :import_at, :deleted_at
  json.url torrent_url(torrent, format: :json)
end
