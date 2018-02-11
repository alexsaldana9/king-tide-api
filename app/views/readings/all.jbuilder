json.array! readings do |reading|
  json.partial! 'details', locals: { reading: reading }
end