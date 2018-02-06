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
  description: 'Flood at Vizcaya',
  approved: false,
  deleted: false
)

Reading.create(
  depth: 4.0,
  units_depth: 'inches',
  salinity: 50,
  units_salinity: 'ppt',
  description: 'Flood at Brickell',
  approved: false,
  deleted: false
)
