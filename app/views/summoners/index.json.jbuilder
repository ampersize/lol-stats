json.array!(@summoners) do |summoner|
  json.extract! summoner, :id, :name
  json.url summoner_url(summoner, format: :json)
end
