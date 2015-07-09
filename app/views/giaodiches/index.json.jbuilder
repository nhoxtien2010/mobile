json.array!(@giaodiches) do |giaodich|
  json.extract! giaodich, :id
  json.url giaodich_url(giaodich, format: :json)
end
