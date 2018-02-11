json.id reading.id
json.depth reading.depth
json.units_depth reading.units_depth
json.salinity reading.salinity
json.units_salinity reading.units_salinity
json.description reading.description
json.approved reading.approved
json.created_at reading.created_at
json.updated_at reading.updated_at
json.latitude reading.latitude
json.longitude reading.longitude
json.photos reading.photos do |photo|
  json.id photo.id
  json.category photo.category
  json.url photo.image.url
  json.url_thumb photo.image.url(:thumb)
  json.url_medium photo.image.url(:medium)
end