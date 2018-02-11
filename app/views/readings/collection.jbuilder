json.array! readings do |reading|
  json.partial! 'item', locals: { reading: reading }
end