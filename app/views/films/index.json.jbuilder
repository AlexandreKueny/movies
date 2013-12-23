json.array!(@films) do |film|
  json.extract! film, :id, :name, :size, :path, :comment
  json.url film_url(film, format: :json)
end
