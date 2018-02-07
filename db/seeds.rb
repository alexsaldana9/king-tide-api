# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Reading.destroy_all

Reading.create(
  depth: 2.0,
  units_depth: 'inches',
  salinity: 100,
  units_salinity: 'ppt',
  description: 'Flood at Vizcaya'
)

Reading.create(
  depth: 4.0,
  units_depth: 'inches',
  salinity: 50,
  units_salinity: 'ppt',
  description: 'Flood at Brickell'
)

p "Reading.count:              #{Reading.count}"
p "Reading.with_deleted.count: #{Reading.with_deleted.count}"
p "Photo.count:                #{Photo.count}"
p "Photo.with_deleted.count:   #{Photo.with_deleted.count}"