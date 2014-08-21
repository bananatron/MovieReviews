json.array!(@reviews) do |review|
  json.extract! review, :id, :movie, :rating, :score, :summary
  json.url review_url(review, format: :json)
end
