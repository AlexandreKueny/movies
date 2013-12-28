json.array!(@t_films) do |t_film|
  json.extract! t_film, :id, :name, :size, :torrent
  json.url t_film_url(t_film, format: :json)
end
