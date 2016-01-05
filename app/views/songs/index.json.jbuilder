json.array!(@songs) do |song|
  json.extract! song, :id, :title, :file
  json.url song_url(song, format: :json)
end
